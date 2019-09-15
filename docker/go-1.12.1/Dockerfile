# Go cross compiler (xgo): Go 1.12.1
# Copyright (c) 2018 Péter Szilágyi. All rights reserved.
# Copyright (c) 2019 CrazyMax
#
# Released under the MIT license.

FROM crazymax/xgo:base

# Configure the root Go distribution and bootstrap based on it
ENV GO_VERSION 1121

RUN \
  export ROOT_DIST=https://storage.googleapis.com/golang/go1.12.1.linux-amd64.tar.gz      && \
  export ROOT_DIST_SHA=2a3fdabf665496a0db5f41ec6af7a9b15a49fbe71a85a50ca38b1f13a103aeec && \
  \
$BOOTSTRAP_PURE
