# syntax=docker/dockerfile:1

ARG GO_VERSION="1.23.0"
ARG OSXCROSS_VERSION="11.3"
ARG GHQ_VERSION="1.6.1"
ARG XX_VERSION="1.3.0"
ARG ALPINE_VERSION="3.19"
ARG PLATFORMS="linux/386 linux/amd64 linux/arm64 linux/arm/v5 linux/arm/v6 linux/arm/v7 linux/mips linux/mipsle linux/mips64 linux/mips64le linux/ppc64le linux/riscv64 linux/s390x windows/386 windows/amd64"

FROM --platform=$BUILDPLATFORM tonistiigi/xx:${XX_VERSION} AS xx
FROM --platform=$BUILDPLATFORM golang:1.22-alpine${ALPINE_VERSION} AS base
COPY --from=xx / /
ENV CGO_ENABLED=0
RUN apk add --no-cache file git
WORKDIR /src

FROM base AS ghq
ARG GHQ_VERSION
RUN --mount=type=cache,target=/go/pkg/mod \
  go install github.com/x-motemen/ghq@v${GHQ_VERSION}

FROM base AS version
RUN --mount=target=. \
  echo $(git describe --match 'v[0-9]*' --dirty='.m' --always --tags) | tee /tmp/.version

FROM base AS vendored
RUN --mount=type=bind,source=.,rw \
  --mount=type=cache,target=/go/pkg/mod \
  go mod tidy && go mod download

FROM vendored AS build
ARG TARGETPLATFORM
RUN --mount=type=bind,target=. \
    --mount=type=bind,from=version,source=/tmp/.version,target=/tmp/.version \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/go/pkg/mod <<EOT
  set -ex
  xx-go build -trimpath -ldflags "-s -w -X main.version=$(cat /tmp/.version)" -o /usr/bin/xgo .
  xx-verify --static /usr/bin/xgo
EOT

FROM scratch AS binary-unix
COPY --link --from=build /usr/bin/xgo /

FROM scratch AS binary-windows
COPY --link --from=build /usr/bin/xgo /xgo.exe

FROM binary-unix AS binary-darwin
FROM binary-unix AS binary-linux
FROM binary-$TARGETOS AS binary

FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION} AS build-artifact
RUN apk add --no-cache bash tar zip
WORKDIR /work
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
RUN --mount=type=bind,target=/src \
    --mount=type=bind,from=binary,target=/build \
    --mount=type=bind,from=version,source=/tmp/.version,target=/tmp/.version <<EOT
  set -ex
  mkdir /out
  version=$(cat /tmp/.version)
  cp /build/* /src/LICENSE /src/README.md .
  if [ "$TARGETOS" = "windows" ]; then
    zip -r "/out/xgo_${version#v}_${TARGETOS}_${TARGETARCH}${TARGETVARIANT}.zip" .
  else
    tar -czvf "/out/xgo_${version#v}_${TARGETOS}_${TARGETARCH}${TARGETVARIANT}.tar.gz" .
  fi
EOT

FROM scratch AS artifact
COPY --link --from=build-artifact /out /

FROM scratch AS artifacts
FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION} AS releaser
RUN apk add --no-cache bash coreutils
WORKDIR /out
RUN --mount=from=artifacts,source=.,target=/artifacts <<EOT
  set -e
  cp /artifacts/**/* /out/ 2>/dev/null || cp /artifacts/* /out/
  sha256sum -b xgo_* > ./checksums.txt
  sha256sum -c --strict checksums.txt
EOT

FROM scratch AS release
COPY --link --from=releaser /out /

FROM crazymax/goxx:${GO_VERSION} AS goxx-base
ARG PLATFORMS
RUN <<EOT
  set -e
  export GOXX_SKIP_APT_PORTS=1
  export DEBIAN_FRONTEND="noninteractive"
  apt-get update
  apt-get install --no-install-recommends -y git zip
  for p in $PLATFORMS; do
    TARGETPLATFORM=$p goxx-apt-get install -y binutils gcc g++ pkg-config
  done
  apt-get -y autoremove
  apt-get clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  ln -sf /usr/include/asm-generic /usr/include/asm
EOT

FROM crazymax/osxcross:${OSXCROSS_VERSION} AS osxcross
FROM goxx-base
COPY --from=build /usr/bin/xgo /usr/local/bin/xgo
COPY --from=ghq /go/bin/ghq /usr/local/bin/ghq
COPY --from=osxcross /osxcross /osxcross

ENV XGO_IN_XGO="1"
ARG GO_VERSION
ENV GO_VERSION=${GO_VERSION}
COPY rootfs /
RUN xgo-bootstrap-pure

ENV DARWIN_DEFAULT_TARGET="10.16"
ENV WINDOWS_DEFAULT_TARGET="4.0"
WORKDIR /
ENTRYPOINT [ "xgo-build" ]
