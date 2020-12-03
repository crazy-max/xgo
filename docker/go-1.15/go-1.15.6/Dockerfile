ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1156

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.15.6.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=3918e6cc85e7eaaa6f859f1bdbaac772e7a825b0eb423c63d3ae68b21f84b844 && \
  \
$BOOTSTRAP_PURE
