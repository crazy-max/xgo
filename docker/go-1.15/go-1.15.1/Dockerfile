ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:base
FROM ${BASE_IMAGE}

ENV GO_VERSION 1151

RUN \
  export ROOT_DIST=https://golang.org/dl/go1.15.1.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=70ac0dbf60a8ee9236f337ed0daa7a4c3b98f6186d4497826f68e97c0c0413f6 && \
  \
$BOOTSTRAP_PURE
