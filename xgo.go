// Wrapper around the GCO cross compiler docker container.
package main

import (
	"flag"
	"fmt"
	"go/build"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

var version = "dev"
var depsCache = filepath.Join(os.TempDir(), "xgo-cache")

// Cross compilation docker containers
var dockerDist = "ghcr.io/crazy-max/xgo"

// Command line arguments to fine tune the compilation
var (
	goVersion   = flag.String("go", "latest", "Go release to use for cross compilation")
	goProxy     = flag.String("goproxy", "", "Set a Global Proxy for Go Modules")
	srcPackage  = flag.String("pkg", "", "Sub-package to build if not root import")
	srcRemote   = flag.String("remote", "", "Version control remote repository to build")
	srcBranch   = flag.String("branch", "", "Version control branch to build")
	outPrefix   = flag.String("out", "", "Prefix to use for output naming (empty = package name)")
	outFolder   = flag.String("dest", "", "Destination folder to put binaries in (empty = current)")
	crossDeps   = flag.String("deps", "", "CGO dependencies (configure/make based archives)")
	crossArgs   = flag.String("depsargs", "", "CGO dependency configure arguments")
	targets     = flag.String("targets", "*/*", "Comma separated targets to build for")
	dockerRepo  = flag.String("docker-repo", "", "Use custom docker repo instead of official distribution")
	dockerImage = flag.String("docker-image", "", "Use custom docker image instead of official distribution")
)

// ConfigFlags is a simple set of flags to define the environment and dependencies.
type ConfigFlags struct {
	Repository   string   // Root import path to build
	Package      string   // Sub-package to build if not root import
	Prefix       string   // Prefix to use for output naming
	Remote       string   // Version control remote repository to build
	Branch       string   // Version control branch to build
	Dependencies string   // CGO dependencies (configure/make based archives)
	Arguments    string   // CGO dependency configure arguments
	Targets      []string // Targets to build for
}

// Command line arguments to pass to go build
var (
	buildVerbose  = flag.Bool("v", false, "Print the names of packages as they are compiled")
	buildSteps    = flag.Bool("x", false, "Print the command as executing the builds")
	buildRace     = flag.Bool("race", false, "Enable data race detection (supported only on amd64)")
	buildTags     = flag.String("tags", "", "List of build tags to consider satisfied during the build")
	buildLdFlags  = flag.String("ldflags", "", "Arguments to pass on each go tool link invocation")
	buildMode     = flag.String("buildmode", "default", "Indicates which kind of object file to build")
	buildVCS      = flag.String("buildvcs", "", "Whether to stamp binaries with version control information")
	buildTrimPath = flag.Bool("trimpath", false, "Remove all file system paths from the resulting executable")
)

// BuildFlags is a simple collection of flags to fine tune a build.
type BuildFlags struct {
	Verbose  bool   // Print the names of packages as they are compiled
	Steps    bool   // Print the command as executing the builds
	Race     bool   // Enable data race detection (supported only on amd64)
	Tags     string // List of build tags to consider satisfied during the build
	LdFlags  string // Arguments to pass on each go tool link invocation
	Mode     string // Indicates which kind of object file to build
	VCS      string // Whether to stamp binaries with version control information
	TrimPath bool   // Remove all file system paths from the resulting executable
}

func main() {
	log.SetFlags(0)
	defer log.Println("INFO: Completed!")
	log.Printf("INFO: Starting xgo/%s", version)

	// Retrieve the CLI flags and the execution environment
	flag.Parse()

	xgoInXgo := os.Getenv("XGO_IN_XGO") == "1"
	if xgoInXgo {
		depsCache = "/deps-cache"
	}
	// Only use docker images if we're not already inside out own image
	image := ""

	if !xgoInXgo {
		// Ensure docker is available
		if err := checkDocker(); err != nil {
			log.Fatalf("ERROR: Failed to check docker installation: %v.", err)
		}
		// Validate the command line arguments
		if len(flag.Args()) != 1 {
			log.Fatalf("Usage: %s [options] <go import path>", os.Args[0])
		}
		// Select the image to use, either official or custom
		image = fmt.Sprintf("%s:%s", dockerDist, *goVersion)
		if *dockerImage != "" {
			image = *dockerImage
		} else if *dockerRepo != "" {
			image = fmt.Sprintf("%s:%s", *dockerRepo, *goVersion)
		}
		// Check that all required images are available
		found := checkDockerImage(image)
		switch {
		case !found:
			fmt.Println("not found!")
			if err := pullDockerImage(image); err != nil {
				log.Fatalf("ERROR: Failed to pull docker image from the registry: %v.", err)
			}
		default:
			log.Println("INFO: Docker image found!")
		}
	}
	// Cache all external dependencies to prevent always hitting the internet
	if *crossDeps != "" {
		if err := os.MkdirAll(depsCache, 0751); err != nil {
			log.Fatalf("ERROR: Failed to create dependency cache: %v.", err)
		}
		// Download all missing dependencies
		for _, dep := range strings.Split(*crossDeps, " ") {
			if url := strings.TrimSpace(dep); len(url) > 0 {
				path := filepath.Join(depsCache, filepath.Base(url))

				if _, err := os.Stat(path); err != nil {
					log.Printf("INFO: Downloading new dependency: %s...", url)
					out, err := os.Create(path)
					if err != nil {
						log.Fatalf("ERROR: Failed to create dependency file: %v", err)
					}
					res, err := http.Get(url)
					if err != nil {
						log.Fatalf("ERROR: Failed to retrieve dependency: %v", err)
					}
					defer res.Body.Close()

					if _, err := io.Copy(out, res.Body); err != nil {
						log.Fatalf("INFO: Failed to download dependency: %v", err)
					}
					out.Close()

					log.Printf("INFO: New dependency cached: %s.", path)
				} else {
					fmt.Printf("INFO: Dependency already cached: %s.", path)
				}
			}
		}
	}
	// Assemble the cross compilation environment and build options
	config := &ConfigFlags{
		Repository:   flag.Args()[0],
		Package:      *srcPackage,
		Remote:       *srcRemote,
		Branch:       *srcBranch,
		Prefix:       *outPrefix,
		Dependencies: *crossDeps,
		Arguments:    *crossArgs,
		Targets:      strings.Split(*targets, ","),
	}
	log.Printf("DBG: config: %+v", config)
	flags := &BuildFlags{
		Verbose:  *buildVerbose,
		Steps:    *buildSteps,
		Race:     *buildRace,
		Tags:     *buildTags,
		LdFlags:  *buildLdFlags,
		Mode:     *buildMode,
		VCS:      *buildVCS,
		TrimPath: *buildTrimPath,
	}
	log.Printf("DBG: flags: %+v", flags)
	folder, err := os.Getwd()
	if err != nil {
		log.Fatalf("ERROR: Failed to retrieve the working directory: %v.", err)
	}
	if *outFolder != "" {
		folder, err = filepath.Abs(*outFolder)
		if err != nil {
			log.Fatalf("ERROR: Failed to resolve destination path (%s): %v.", *outFolder, err)
		}
	}
	// Execute the cross compilation, either in a container or the current system
	if !xgoInXgo {
		err = compile(image, config, flags, folder)
	} else {
		err = compileContained(config, flags, folder)
	}
	if err != nil {
		log.Fatalf("ERROR: Failed to cross compile package: %v.", err)
	}
}

// Checks whether a docker installation can be found and is functional.
func checkDocker() error {
	log.Println("INFO: Checking docker installation...")
	if err := run(exec.Command("docker", "version")); err != nil {
		return err
	}
	fmt.Println()
	return nil
}

// Checks whether a required docker image is available locally.
func checkDockerImage(image string) bool {
	log.Printf("INFO: Checking for required docker image %s... ", image)
	err := exec.Command("docker", "image", "inspect", image).Run()
	return err == nil
}

// Pulls an image from the docker registry.
func pullDockerImage(image string) error {
	log.Printf("INFO: Pulling %s from docker registry...", image)
	return run(exec.Command("docker", "pull", image))
}

// compile cross builds a requested package according to the given build specs
// using a specific docker cross compilation image.
func compile(image string, config *ConfigFlags, flags *BuildFlags, folder string) error {
	// If a local build was requested, find the import path and mount all GOPATH sources
	locals, mounts, paths := []string{}, []string{}, []string{}
	var usesModules bool
	if strings.HasPrefix(config.Repository, string(filepath.Separator)) || strings.HasPrefix(config.Repository, ".") {
		if fileExists(filepath.Join(config.Repository, "go.mod")) {
			usesModules = true
		}
		if !usesModules {
			// Resolve the repository import path from the file path
			config.Repository = resolveImportPath(config.Repository)
			if fileExists(filepath.Join(config.Repository, "go.mod")) {
				usesModules = true
			}
		}
		if !usesModules {
			log.Println("INFO: go.mod not found. Skipping go modules")
		}

		gopathEnv := os.Getenv("GOPATH")
		if gopathEnv == "" && !usesModules {
			log.Printf("INFO: No $GOPATH is set - defaulting to %s", build.Default.GOPATH)
			gopathEnv = build.Default.GOPATH
		}

		// Iterate over all the local libs and export the mount points
		if gopathEnv == "" && !usesModules {
			log.Fatalf("INFO: No $GOPATH is set or forwarded to xgo")
		}

		if !usesModules {
			os.Setenv("GO111MODULE", "off")
			for _, gopath := range strings.Split(gopathEnv, string(os.PathListSeparator)) {
				// Since docker sandboxes volumes, resolve any symlinks manually
				sources := filepath.Join(gopath, "src")
				filepath.Walk(sources, func(path string, info os.FileInfo, err error) error {
					// Skip any folders that errored out
					if err != nil {
						log.Printf("WARNING: Failed to access GOPATH element %s: %v", path, err)
						return nil
					}
					// Skip anything that's not a symlink
					if info.Mode()&os.ModeSymlink == 0 {
						return nil
					}
					// Resolve the symlink and skip if it's not a folder
					target, err := filepath.EvalSymlinks(path)
					if err != nil {
						return nil
					}
					if info, err = os.Stat(target); err != nil || !info.IsDir() {
						return nil
					}
					// Skip if the symlink points within GOPATH
					if filepath.HasPrefix(target, sources) {
						return nil
					}

					// Folder needs explicit mounting due to docker symlink security
					locals = append(locals, target)
					mounts = append(mounts, filepath.Join("/ext-go", strconv.Itoa(len(locals)), "src", strings.TrimPrefix(path, sources)))
					paths = append(paths, filepath.ToSlash(filepath.Join("/ext-go", strconv.Itoa(len(locals)))))
					return nil
				})
				// Export the main mount point for this GOPATH entry
				locals = append(locals, sources)
				mounts = append(mounts, filepath.Join("/ext-go", strconv.Itoa(len(locals)), "src"))
				paths = append(paths, filepath.ToSlash(filepath.Join("/ext-go", strconv.Itoa(len(locals)))))
			}
		}
	}
	// Assemble and run the cross compilation command
	log.Printf("INFO: Cross compiling %s package...", config.Repository)

	args := []string{
		"run", "--rm",
		"-v", folder + ":/build",
		"-v", depsCache + ":/deps-cache:ro",
		"-e", "REPO_REMOTE=" + config.Remote,
		"-e", "REPO_BRANCH=" + config.Branch,
		"-e", "PACK=" + config.Package,
		"-e", "DEPS=" + config.Dependencies,
		"-e", "ARGS=" + config.Arguments,
		"-e", "OUT=" + config.Prefix,
		"-e", fmt.Sprintf("FLAG_V=%v", flags.Verbose),
		"-e", fmt.Sprintf("FLAG_X=%v", flags.Steps),
		"-e", fmt.Sprintf("FLAG_RACE=%v", flags.Race),
		"-e", fmt.Sprintf("FLAG_TAGS=%s", flags.Tags),
		"-e", fmt.Sprintf("FLAG_LDFLAGS=%s", flags.LdFlags),
		"-e", fmt.Sprintf("FLAG_BUILDMODE=%s", flags.Mode),
		"-e", fmt.Sprintf("FLAG_BUILDVCS=%s", flags.VCS),
		"-e", fmt.Sprintf("FLAG_TRIMPATH=%v", flags.TrimPath),
		"-e", "TARGETS=" + strings.Replace(strings.Join(config.Targets, " "), "*", ".", -1),
	}
	if usesModules {
		args = append(args, []string{"-e", "GO111MODULE=on"}...)
		args = append(args, []string{"-v", build.Default.GOPATH + ":/go"}...)
		if *goProxy != "" {
			args = append(args, []string{"-e", fmt.Sprintf("GOPROXY=%s", *goProxy)}...)
		}

		// Map this repository to the /source folder
		absRepository, err := filepath.Abs(config.Repository)
		if err != nil {
			log.Fatalf("ERROR: Failed to locate requested module repository: %v.", err)
		}
		args = append(args, []string{"-v", absRepository + ":/source"}...)

		// Check whether it has a vendor folder, and if so, use it
		vendorPath := absRepository + "/vendor"
		vendorfolder, err := os.Stat(vendorPath)
		if !os.IsNotExist(err) && vendorfolder.Mode().IsDir() {
			args = append(args, []string{"-e", "FLAG_MOD=vendor"}...)
			log.Printf("INFO: Using vendored Go module dependencies")
		}
	} else {
		for i := 0; i < len(locals); i++ {
			args = append(args, []string{"-v", fmt.Sprintf("%s:%s:ro", locals[i], mounts[i])}...)
		}
		args = append(args, []string{"-e", "EXT_GOPATH=" + strings.Join(paths, ":")}...)
	}

	args = append(args, []string{image, config.Repository}...)
	log.Printf("INFO: Docker %s", strings.Join(args, " "))
	return run(exec.Command("docker", args...))
}

// compileContained cross builds a requested package according to the given build
// specs using the current system opposed to running in a container. This is meant
// to be used for cross compilation already from within an xgo image, allowing the
// inheritance and bundling of the root xgo images.
func compileContained(config *ConfigFlags, flags *BuildFlags, folder string) error {
	// If a local build was requested, resolve the import path
	local := strings.HasPrefix(config.Repository, string(filepath.Separator)) || strings.HasPrefix(config.Repository, ".")
	if local {
		// Resolve the repository import path from the file path
		config.Repository = resolveImportPath(config.Repository)

		// Determine if this is a module-based repository
		usesModules := fileExists(filepath.Join(config.Repository, "go.mod"))
		if !usesModules {
			os.Setenv("GO111MODULE", "off")
			log.Println("INFO: Don't use go modules (go.mod not found)")
		}
	}
	// Fine tune the original environment variables with those required by the build script
	env := []string{
		"REPO_REMOTE=" + config.Remote,
		"REPO_BRANCH=" + config.Branch,
		"PACK=" + config.Package,
		"DEPS=" + config.Dependencies,
		"ARGS=" + config.Arguments,
		"OUT=" + config.Prefix,
		fmt.Sprintf("FLAG_V=%v", flags.Verbose),
		fmt.Sprintf("FLAG_X=%v", flags.Steps),
		fmt.Sprintf("FLAG_RACE=%v", flags.Race),
		fmt.Sprintf("FLAG_TAGS=%s", flags.Tags),
		fmt.Sprintf("FLAG_LDFLAGS=%s", flags.LdFlags),
		fmt.Sprintf("FLAG_BUILDMODE=%s", flags.Mode),
		fmt.Sprintf("FLAG_BUILDVCS=%s", flags.VCS),
		fmt.Sprintf("FLAG_TRIMPATH=%v", flags.TrimPath),
		"TARGETS=" + strings.Replace(strings.Join(config.Targets, " "), "*", ".", -1),
	}
	if local {
		env = append(env, "EXT_GOPATH=/non-existent-path-to-signal-local-build")
	}
	// Assemble and run the local cross compilation command
	log.Printf("INFO: Cross compiling %s package...", config.Repository)

	cmd := exec.Command("xgo-build", config.Repository)
	cmd.Env = append(os.Environ(), env...)

	return run(cmd)
}

// resolveImportPath converts a package given by a relative path to a Go import
// path using the local GOPATH environment.
func resolveImportPath(path string) string {
	abs, err := filepath.Abs(path)
	if err != nil {
		log.Fatalf("ERROR: Failed to locate requested package: %v.", err)
	}
	stat, err := os.Stat(abs)
	if err != nil || !stat.IsDir() {
		log.Fatalf("ERROR: Requested path invalid.")
	}
	pack, err := build.ImportDir(abs, build.FindOnly)
	if err != nil {
		log.Fatalf("ERROR: Failed to resolve import path: %v.", err)
	}
	return pack.ImportPath
}

// Executes a command synchronously, redirecting its output to stdout.
func run(cmd *exec.Cmd) error {
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.Run()
}

// fileExists checks if given file exists
func fileExists(file string) bool {
	if _, err := os.Stat(file); os.IsNotExist(err) {
		return false
	}
	return true
}
