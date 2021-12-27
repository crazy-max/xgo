ARG UBUNTU_VERSION="21.04"
ARG OSX_SDK="MacOSX11.1.sdk"
ARG OSX_SDK_URL="https://github.com/larskanis/MacOSX-SDKs/releases/download/11.1/${OSX_SDK}.tar.xz"
ARG OSX_CROSS_COMMIT="035cc170338b7b252e3f13b0e3ccbf4411bffc41"
#ARG LLVM_MINGW_URL="https://github.com/mstorsjo/llvm-mingw/releases/download/20210816/llvm-mingw-20210816-msvcrt-ubuntu-18.04-x86_64.tar.xz"

FROM ubuntu:${UBUNTU_VERSION} AS base
RUN export DEBIAN_FRONTEND="noninteractive" \
  && apt-get update \
  && apt-get install -y \
    autoconf \
    automake \
    bash \
    bc \
    binutils-multiarch-dev \
    build-essential \
    bzr \
    ca-certificates \
    clang \
    cmake \
    cpio \
    crossbuild-essential-amd64 \
    crossbuild-essential-arm64 \
    crossbuild-essential-armel \
    crossbuild-essential-armhf \
    crossbuild-essential-i386 \
    crossbuild-essential-mips \
    crossbuild-essential-mipsel \
    crossbuild-essential-mips64 \
    crossbuild-essential-mips64el \
    crossbuild-essential-ppc64el \
    crossbuild-essential-riscv64 \
    crossbuild-essential-s390x \
    curl \
    g++ \
    g++-mingw-w64 \
    gcc \
    gcc-mingw-w64 \
    gdb \
    git \
    help2man \
    libssl-dev \
    libtool \
    linux-headers-generic \
    llvm-dev \
    lzma-dev \
    make \
    mercurial \
    musl-tools \
    multistrap \
    patch \
    pkg-config \
    swig \
    texinfo \
    tzdata \
    unzip \
    wget \
    xz-utils \
    zip \
  && apt-get install -y \
    lib32asan6 \
    lib32atomic1 \
    lib32gcc-10-dev \
    lib32gomp1 \
    lib32itm1 \
    lib32quadmath0 \
    lib32stdc++-10-dev \
    lib32ubsan1 \
    libc6-dev-i386 \
    libc6-dev-x32 \
    libc6-x32 \
    libx32asan6 \
    libx32atomic1 \
    libx32gcc-10-dev \
    libx32gcc-s1 \
    libx32gomp1 \
    libx32itm1 \
    libx32quadmath0 \
    libx32stdc++-10-dev \
    libx32stdc++6 \
    libx32ubsan1 \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && ln -sf /usr/include/asm-generic /usr/include/asm

FROM base as osxcross

RUN export DEBIAN_FRONTEND="noninteractive" \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    autotools-dev \
    libgmp-dev \
    libmpc-dev \
    libmpfr-dev \
    libxml2-dev \
    llvm-dev \
    lzma-dev \
    uuid-dev \
    zlib1g-dev

WORKDIR /tmp
ARG OSX_VERSION
ARG OSX_SDK
ARG OSX_SDK_URL
RUN wget -q $OSX_SDK_URL \
  && tar -xf $(basename $OSX_SDK_URL) \
  && rm -f $(basename $OSX_SDK_URL)
ADD patch.tar.xz "$OSX_SDK/usr/include/c++"
RUN tar -cf - $OSX_SDK/ | xz -c - > /$OSX_SDK.tar.xz

WORKDIR /osxcross
ARG OSX_CROSS_COMMIT
RUN git clone https://github.com/tpoechtrager/osxcross.git . \
  && git reset --hard $OSX_CROSS_COMMIT \
  && mv /$OSX_SDK.tar.xz /osxcross/tarballs/ \
  && OSX_VERSION_MIN=10.10 UNATTENDED=1 /osxcross/build.sh

FROM base
COPY --from=osxcross /osxcross/target /osxcross/target
ENV PATH="/osxcross/target/bin:$PATH"
RUN curl -sSLk https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver -o /usr/local/bin/semver && chmod +x /usr/local/bin/semver
COPY rootfs /
