# syntax=docker/dockerfile:1-labs

ARG GO_VERSION="1.17.5"
ARG GORELEASER_XX_VERSION="1.2.2"
ARG PLATFORMS="linux/386 linux/amd64 linux/arm64 linux/arm/v5 linux/arm/v6 linux/arm/v7 linux/mips linux/mipsle linux/mips64 linux/mips64le linux/ppc64le linux/riscv64 linux/s390x windows/386 windows/amd64"

FROM --platform=$BUILDPLATFORM crazymax/goreleaser-xx:${GORELEASER_XX_VERSION} AS goreleaser-xx
FROM --platform=$BUILDPLATFORM golang:1.17-alpine AS base
ENV CGO_ENABLED=0
COPY --from=goreleaser-xx / /
RUN apk add --no-cache file git
WORKDIR /src

FROM base AS vendored
RUN --mount=type=bind,source=.,rw \
  --mount=type=cache,target=/go/pkg/mod \
  go mod tidy && go mod download

FROM vendored AS build
ARG TARGETPLATFORM
RUN --mount=type=bind,source=.,rw \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/go/pkg/mod \
  goreleaser-xx --debug \
    --name "xgo" \
    --dist "/out" \
    --flags="-trimpath" \
    --ldflags="-s -w -X 'main.version={{.Version}}'" \
    --files="CHANGELOG.md" \
    --files="LICENSE" \
    --files="README.md" \
    --replacements="386=i386" \
    --replacements="amd64=x86_64"

FROM scratch AS artifact
COPY --from=build /out/*.tar.gz /
COPY --from=build /out/*.zip /

FROM crazymax/goxx:${GO_VERSION} AS goxx-base
ARG PLATFORMS
RUN <<EOT
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

FROM goxx-base
COPY --from=build /usr/local/bin/xgo /usr/local/bin/xgo

ENV XGO_IN_XGO="1"
ARG GO_VERSION
ENV GO_VERSION=${GO_VERSION}
COPY rootfs /
RUN xgo-bootstrap-pure
WORKDIR /
ENTRYPOINT [ "xgo-build" ]
