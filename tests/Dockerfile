# syntax=docker/dockerfile:1

ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:1.17.x
ARG PROJECT="./c"
ARG BRANCH=""

FROM ${BASE_IMAGE} AS base
WORKDIR /src
ARG PROJECT
ARG BRANCH
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/go/pkg/mod \
  ROOTPATH=$(case $PROJECT in \
    .*)  echo "."                ;; \
    *)   echo "$PROJECT"         ;; esac) \
  && if [ "$ROOTPATH" = "." ]; then cd $PROJECT; fi \
  && xgo -targets="*/*" -branch="$BRANCH" -out="test" $ROOTPATH \
  && ls -al /build
