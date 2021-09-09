// xgo base image
variable "BASE_IMAGE" {
  default = "ghcr.io/crazy-max/xgo:base"
}

// GitHub reference as defined in GitHub Actions (eg. refs/head/master))
variable "GITHUB_REF" {
  default = ""
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["xgo:local"]
}

group "default" {
  targets = ["base"]
}

#
#
#

target "base-image" {
  args = {
    BASE_IMAGE = BASE_IMAGE
  }
}

target "base" {
  inherits = ["docker-metadata-action"]
  context = "./base"
}

target "base-local" {
  inherits = ["base"]
  tags = ["xgo:base"]
  output = ["type=docker"]
}

#
#
#

target "git-ref" {
  args = {
    GIT_REF = GITHUB_REF
  }
}

target "artifact" {
  inherits = ["git-ref", "docker-metadata-action"]
  target = "xgo-artifact"
  output = ["./dist"]
}

target "artifact-all" {
  inherits = ["artifact"]
  platforms = [
    "linux/amd64",
    "linux/arm/v5",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/386",
    "linux/ppc64le",
    "linux/s390x",
    "windows/amd64",
    "windows/386",
    "darwin/amd64"
  ]
}

#
#
#

target "test" {
  inherits = ["base-image"]
  context = "./tests"
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

target "test-goethereum" {
  inherits = ["test"]
  args = {
    PROJECT = "github.com/ethereum/go-ethereum/cmd/geth"
    BRANCH = "master"
  }
}

#
#
#

target "go" {
  inherits = ["base-image", "git-ref", "docker-metadata-action"]
  target = "go"
}

target "go-1.17" {
  inherits = ["go-1.17.1"]
}

target "go-1.17.1" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.17.1"
    GO_DIST_SHA = "dab7d9c34361dc21ec237d584590d72500652e7c909bf082758fb63064fca0ef"
  }
}

target "go-1.17.0" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.17"
    GO_DIST_SHA = "6bf89fc4f5ad763871cf7eac80a2d594492de7a818303283f1366a7f6a30372d"
  }
}

target "go-1.16" {
  inherits = ["go-1.16.8"]
}

target "go-1.16.8" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.8"
    GO_DIST_SHA = "f32501aeb8b7b723bc7215f6c373abb6981bbc7e1c7b44e9f07317e1a300dce2"
  }
}

target "go-1.16.7" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.7"
    GO_DIST_SHA = "7fe7a73f55ba3e2285da36f8b085e5c0159e9564ef5f63ee0ed6b818ade8ef04"
  }
}

target "go-1.16.6" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.6"
    GO_DIST_SHA = "be333ef18b3016e9d7cb7b1ff1fdb0cac800ca0be4cf2290fe613b3d069dfe0d"
  }
}

target "go-1.16.5" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.5"
    GO_DIST_SHA = "b12c23023b68de22f74c0524f10b753e7b08b1504cb7e417eccebdd3fae49061"
  }
}

target "go-1.16.4" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.4"
    GO_DIST_SHA = "7154e88f5a8047aad4b80ebace58a059e36e7e2e4eb3b383127a28c711b4ff59"
  }
}

target "go-1.16.3" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.3"
    GO_DIST_SHA = "951a3c7c6ce4e56ad883f97d9db74d3d6d80d5fec77455c6ada6c1f7ac4776d2"
  }
}

target "go-1.16.2" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.2"
    GO_DIST_SHA = "542e936b19542e62679766194364f45141fde55169db2d8d01046555ca9eb4b8"
  }
}

target "go-1.16.1" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.1"
    GO_DIST_SHA = "3edc22f8332231c3ba8be246f184b736b8d28f06ce24f08168d8ecf052549769"
  }
}

target "go-1.16.0" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16"
    GO_DIST_SHA = "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2"
  }
}
