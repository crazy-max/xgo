ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1159

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.15.9.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=a55f3e75bc1098045851d40ea74f9d77efc7958e9af85131a96ca387d38b1834 && \
  \
$BOOTSTRAP_PURE
