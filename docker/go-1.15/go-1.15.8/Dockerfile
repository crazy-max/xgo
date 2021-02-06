ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1158

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.15.8.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=d3379c32a90fdf9382166f8f48034c459a8cc433730bc9476d39d9082c94583b && \
  \
$BOOTSTRAP_PURE
