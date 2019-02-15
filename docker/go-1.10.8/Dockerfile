# Go cross compiler (xgo): Go 1.10.8
# Copyright (c) 2018 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM karalabe/xgo-base

# Configure the root Go distribution and bootstrap based on it
ENV GO_VERSION 1108

RUN \
  export ROOT_DIST=https://storage.googleapis.com/golang/go1.10.8.linux-amd64.tar.gz    && \
  export ROOT_DIST_SHA=d8626fb6f9a3ab397d88c483b576be41fa81eefcec2fd18562c87626dbb3c39e && \
  \
  $BOOTSTRAP_PURE
