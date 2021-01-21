ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1157

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.15.7.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=0d142143794721bb63ce6c8a6180c4062bcf8ef4715e7d6d6609f3a8282629b3 && \
  \
$BOOTSTRAP_PURE
