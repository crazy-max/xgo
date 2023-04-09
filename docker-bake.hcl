variable "GO_VERSION" {
  default = null
}

variable "DESTDIR" {
  default = "./bin"
}

target "_common" {
  args = {
    GO_VERSION = GO_VERSION
    BUILDKIT_CONTEXT_KEEP_GIT_DIR = 1
  }
}

# Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["xgo:local"]
}

group "default" {
  targets = ["image-local"]
}

target "base" {
  inherits = ["_common"]
  target = "goxx-base"
  output = ["type=cacheonly"]
}

target "image" {
  inherits = ["_common", "docker-metadata-action"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "artifact" {
  inherits = ["_common", "docker-metadata-action"]
  target = "artifact"
  output = ["${DESTDIR}/artifact"]
}

target "artifact-all" {
  inherits = ["artifact"]
  platforms = [
    "darwin/amd64",
    "darwin/arm64",
    "linux/386",
    "linux/amd64",
    "linux/arm64",
    "linux/arm/v5",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/ppc64le",
    "linux/s390x",
    "windows/amd64",
    "windows/arm64",
    "windows/386"
  ]
}

target "release" {
  target = "release"
  output = ["${DESTDIR}/release"]
  contexts = {
    artifacts = "${DESTDIR}/artifact"
  }
}

variable "BASE_IMAGE" {
  default = "ghcr.io/crazy-max/xgo:latest"
}

target "test" {
  inherits = ["_common"]
  context = "./tests"
  args = {
    BASE_IMAGE = BASE_IMAGE
  }
}

target "test-gorm" {
  inherits = ["test"]
  args = {
    PROJECT = "./gorm"
    BRANCH = ""
  }
}

target "test-c" {
  inherits = ["test"]
  args = {
    PROJECT = "./c"
    BRANCH = ""
  }
}

target "test-cpp" {
  inherits = ["test"]
  args = {
    PROJECT = "./cpp"
    BRANCH = ""
  }
}

target "test-ffmerger" {
  inherits = ["test"]
  args = {
    PROJECT = "github.com/crazy-max/firefox-history-merger"
    BRANCH = "master"
  }
}
