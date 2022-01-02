# syntax=docker/dockerfile:1.3

ARG GO_VERSION="1.17.5"
ARG GORELEASER_XX_VERSION="1.2.2"

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

FROM crazymax/goxx:${GO_VERSION}
COPY --from=build /usr/local/bin/xgo /usr/local/bin/xgo
ENV XGO_IN_XGO="1"
ARG GO_VERSION
ENV GO_VERSION=${GO_VERSION}
COPY rootfs /
RUN xgo-bootstrap-pure
WORKDIR /
ENTRYPOINT [ "xgo-build" ]
