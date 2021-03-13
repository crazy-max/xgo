# syntax=docker/dockerfile:1.2
ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
ARG GO_VERSION
ARG GO_DIST_URL
ARG GO_DIST_SHA

FROM --platform=${BUILDPLATFORM:-linux/amd64} crazymax/goreleaser-xx:latest AS goreleaser-xx
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.13-alpine AS xgo-base
COPY --from=goreleaser-xx / /
RUN apk add --no-cache ca-certificates curl file gcc git linux-headers musl-dev tar
WORKDIR /src

FROM xgo-base AS xgo-build
ARG TARGETPLATFORM
ARG GIT_REF
RUN --mount=type=bind,target=/src,rw \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=target=/go/pkg/mod,type=cache \
  goreleaser-xx --debug \
    --name "xgo" \
    --dist "/out" \
    --ldflags="-s -w -X 'main.version={{.Version}}'" \
    --files="CHANGELOG.md" \
    --files="LICENSE" \
    --files="README.md"

FROM scratch AS xgo-artifact
COPY --from=xgo-build /out/*.tar.gz /
COPY --from=xgo-build /out/*.zip /

FROM ${BASE_IMAGE} AS go
ARG GO_VERSION
ARG GO_DIST_SHA
ARG GO_DIST_URL="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
ENV GO_VERSION=${GO_VERSION}
COPY --from=xgo-build /usr/local/bin/xgo /usr/local/bin/xgo
RUN xgo-bootstrap-pure
