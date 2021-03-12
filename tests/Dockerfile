# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=ghcr.io/crazy-max/xgo:1.16.x
ARG PROJECT="gorm"

FROM ${BASE_IMAGE} AS base
WORKDIR /src

FROM base
ARG PROJECT
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/go/pkg/mod \
  cd $PROJECT \
  && xgo -targets="*/*" -out="$PROJECT" . \
  && ls -al /build
