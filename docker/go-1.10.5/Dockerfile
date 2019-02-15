# Go cross compiler (xgo): Go 1.10.5
# Copyright (c) 2018 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM crazymax/xgo:base

# Configure the root Go distribution and bootstrap based on it
ENV GO_VERSION 1105

RUN \
  export ROOT_DIST=https://storage.googleapis.com/golang/go1.10.5.linux-amd64.tar.gz    && \
  export ROOT_DIST_SHA=a035d9beda8341b645d3f45a1b620cf2d8fb0c5eb409be36b389c0fd384ecc3a && \
  \
  $BOOTSTRAP_PURE
