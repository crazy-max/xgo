ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1161

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.16.1.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=3edc22f8332231c3ba8be246f184b736b8d28f06ce24f08168d8ecf052549769 && \
  \
$BOOTSTRAP_PURE
