# Go cross compiler (xgo): Go 1.11.12
# Copyright (c) 2018 Péter Szilágyi. All rights reserved.
# Copyright (c) 2019 CrazyMax
#
# Released under the MIT license.

FROM crazymax/xgo:base

# Configure the root Go distribution and bootstrap based on it
ENV GO_VERSION 11112

RUN \
  export ROOT_DIST=https://storage.googleapis.com/golang/go1.11.12.linux-amd64.tar.gz    && \
  export ROOT_DIST_SHA=14ec881815eb9e6618f95df5eb385d961283efc196d97912595ba6484a56180d && \
  \
$BOOTSTRAP_PURE
