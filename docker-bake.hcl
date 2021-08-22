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

target "go-1.16" {
  inherits = ["go-1.16.7"]
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

target "go-1.15" {
  inherits = ["go-1.15.15"]
}

target "go-1.15.15" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.15"
    GO_DIST_SHA = "0885cf046a9f099e260d98d9ec5d19ea9328f34c8dc4956e1d3cd87daaddb345"
  }
}

target "go-1.15.14" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.14"
    GO_DIST_SHA = "6f5410c113b803f437d7a1ee6f8f124100e536cc7361920f7e640fedf7add72d"
  }
}

target "go-1.15.13" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.13"
    GO_DIST_SHA = "3d3beec5fc66659018e09f40abb7274b10794229ba7c1e8bdb7d8ca77b656a13"
  }
}

target "go-1.15.12" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.12"
    GO_DIST_SHA = "bbdb935699e0b24d90e2451346da76121b2412d30930eabcd80907c230d098b7"
  }
}

target "go-1.15.11" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.11"
    GO_DIST_SHA = "8825b72d74b14e82b54ba3697813772eb94add3abf70f021b6bdebe193ed01ec"
  }
}

target "go-1.15.10" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.10"
    GO_DIST_SHA = "4aa1267517df32f2bf1cc3d55dfc27d0c6b2c2b0989449c96dd19273ccca051d"
  }
}

target "go-1.15.9" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.9"
    GO_DIST_SHA = "a55f3e75bc1098045851d40ea74f9d77efc7958e9af85131a96ca387d38b1834"
  }
}

target "go-1.15.8" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.8"
    GO_DIST_SHA = "d3379c32a90fdf9382166f8f48034c459a8cc433730bc9476d39d9082c94583b"
  }
}

target "go-1.15.7" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.7"
    GO_DIST_SHA = "0d142143794721bb63ce6c8a6180c4062bcf8ef4715e7d6d6609f3a8282629b3"
  }
}

target "go-1.15.6" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.6"
    GO_DIST_SHA = "3918e6cc85e7eaaa6f859f1bdbaac772e7a825b0eb423c63d3ae68b21f84b844"
  }
}

target "go-1.15.5" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.5"
    GO_DIST_SHA = "9a58494e8da722c3aef248c9227b0e9c528c7318309827780f16220998180a0d"
  }
}

target "go-1.15.4" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.4"
    GO_DIST_SHA = "eb61005f0b932c93b424a3a4eaa67d72196c79129d9a3ea8578047683e2c80d5"
  }
}

target "go-1.15.3" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.3"
    GO_DIST_SHA = "010a88df924a81ec21b293b5da8f9b11c176d27c0ee3962dc1738d2352d3c02d"
  }
}

target "go-1.15.2" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.2"
    GO_DIST_SHA = "b49fda1ca29a1946d6bb2a5a6982cf07ccd2aba849289508ee0f9918f6bb4552"
  }
}

target "go-1.15.1" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15.1"
    GO_DIST_SHA = "70ac0dbf60a8ee9236f337ed0daa7a4c3b98f6186d4497826f68e97c0c0413f6"
  }
}

target "go-1.15.0" {
  inherits = ["go"]
  args = {
    GO_VERSION = "1.15"
    GO_DIST_SHA = "2d75848ac606061efe52a8068d0e647b35ce487a15bb52272c427df485193602"
  }
}
