# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
ARG GO_VERSION
ARG GO_DIST_URL
ARG GO_DIST_SHA

ARG GORELEASER_XX_VERSION="1.2.2"

FROM --platform=$BUILDPLATFORM crazymax/goreleaser-xx:${GORELEASER_XX_VERSION} AS goreleaser-xx
FROM --platform=$BUILDPLATFORM golang:1.17-alpine AS base
ENV CGO_ENABLED=0
COPY --from=goreleaser-xx / /
RUN apk add --no-cache file git
WORKDIR /src

FROM base AS vendored
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/go/pkg/mod \
  go mod tidy && go mod download

FROM vendored AS build
ARG TARGETPLATFORM
RUN --mount=type=bind,target=/src,rw \
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

FROM ${BASE_IMAGE} AS go
ARG GO_VERSION
ARG GO_DIST_SHA
ARG GO_DIST_URL="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
ENV GO_VERSION=${GO_VERSION}
COPY --from=build /usr/local/bin/xgo /usr/local/bin/xgo
RUN xgo-bootstrap-pure
