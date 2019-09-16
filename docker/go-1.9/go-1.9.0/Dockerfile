FROM crazymax/xgo:base

ENV GO_VERSION 190

RUN \
  export ROOT_DIST=https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz       && \
  export ROOT_DIST_SHA=d70eadefce8e160638a9a6db97f7192d8463069ab33138893ad3bf31b0650a79 && \
  \
  $BOOTSTRAP_PURE
