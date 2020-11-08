ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1145

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.14.5.linux-amd64.tar.gz    && \
  export ROOT_DIST_SHA=82a1b84f16858db03231eb201f90cce2a991078dda543879b87e738e2586854b && \
  \
$BOOTSTRAP_PURE
