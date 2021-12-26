variable "BASE_IMAGE" {
  default = "ghcr.io/crazy-max/xgo:base"
}

target "_common" {
  args = {
    BASE_IMAGE = BASE_IMAGE
    BUILDKIT_CONTEXT_KEEP_GIT_DIR = 1
  }
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["xgo:local"]
}

group "default" {
  targets = ["base"]
}

target "base" {
  inherits = ["_common", "docker-metadata-action"]
  context = "./base"
}

target "base-local" {
  inherits = ["base"]
  tags = ["xgo:base"]
  output = ["type=docker"]
}

target "artifact" {
  inherits = ["_common", "docker-metadata-action"]
  target = "artifact"
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
  inherits = ["_common"]
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
  inherits = ["_common", "docker-metadata-action"]
  target = "go"
}

target "go-1.17" {
  inherits = ["go-1.17.5"]
}

target "go-1.17.5" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.17.5"
    GO_DIST_SHA = "bd78114b0d441b029c8fe0341f4910370925a4d270a6a590668840675b0c653e"
  }
}

target "go-1.17.4" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.17.4"
    GO_DIST_SHA = "adab2483f644e2f8a10ae93122f0018cef525ca48d0b8764dae87cb5f4fd4206"
  }
}

target "go-1.17.3" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.17.3"
    GO_DIST_SHA = "550f9845451c0c94be679faf116291e7807a8d78b43149f9506c1b15eb89008c"
  }
}

target "go-1.17.2" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.17.2"
    GO_DIST_SHA = "f242a9db6a0ad1846de7b6d94d507915d14062660616a61ef7c808a76e4f1676"
  }
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
  inherits = ["go-1.16.12"]
}

target "go-1.16.12" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.12"
    GO_DIST_SHA = "7d657e86493ac1d5892f340a7d88b862b12edb5ac6e73c099e8e0668a6c916b7"
  }
}

target "go-1.16.11" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.11"
    GO_DIST_SHA = "aa22d0e2be68c0a7027a64e76cbb2869332fbc42ce14e3d10b69007b51030775"
  }
}

target "go-1.16.10" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.10"
    GO_DIST_SHA = "414cd18ce1d193769b9e97d2401ad718755ab47816e13b2a1cde203d263b55cf"
  }
}

target "go-1.16.9" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.16.9"
    GO_DIST_SHA = "d2c095c95f63c2a3ef961000e0ecb9d81d5c68b6ece176e2a8a2db82dc02931c"
  }
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
