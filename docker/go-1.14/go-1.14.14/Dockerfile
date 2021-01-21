ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 11414

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.14.14.linux-amd64.tar.gz    && \
  export ROOT_DIST_SHA=6f1354c9040d65d1622b451f43c324c1e5197aa9242d00c5a117d0e2625f3e0d && \
  \
$BOOTSTRAP_PURE
