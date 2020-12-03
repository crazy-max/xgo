ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 11413

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.14.13.linux-amd64.tar.gz    && \
  export ROOT_DIST_SHA=bfea0c8d7b70c1ad99b0266b321608db57df75820e8f4333efa448a43da01992 && \
  \
$BOOTSTRAP_PURE
