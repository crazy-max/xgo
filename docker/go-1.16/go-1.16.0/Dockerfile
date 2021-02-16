ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1160

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.16.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2 && \
  \
$BOOTSTRAP_PURE
