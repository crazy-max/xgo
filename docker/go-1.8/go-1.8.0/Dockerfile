FROM crazymax/xgo:base

ENV GO_VERSION 180

RUN \
  export ROOT_DIST=https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz       && \
  export ROOT_DIST_SHA=53ab94104ee3923e228a2cb2116e5e462ad3ebaeea06ff04463479d7f12d27ca && \
  \
  $BOOTSTRAP_PURE
