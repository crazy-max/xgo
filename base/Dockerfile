ARG UBUNTU_VERSION="21.04"
ARG OSX_SDK="MacOSX11.1.sdk"
ARG OSX_SDK_URL="https://github.com/larskanis/MacOSX-SDKs/releases/download/11.1/${OSX_SDK}.tar.xz"
ARG OSX_CROSS_COMMIT="d904031e7e3faa8a23c21b319a65cc915dac51b3"
#ARG LLVM_MINGW_URL="https://github.com/mstorsjo/llvm-mingw/releases/download/20210816/llvm-mingw-20210816-msvcrt-ubuntu-18.04-x86_64.tar.xz"

FROM ubuntu:${UBUNTU_VERSION} AS base
RUN export DEBIAN_FRONTEND="noninteractive" \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    autotools-dev \
    bash \
    bc \
    binutils-multiarch \
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
    devscripts \
    g++ \
    g++-mingw-w64 \
    gcc \
    gcc-mingw-w64 \
    gdb \
    git \
    help2man \
    libgmp-dev \
    libmpc-dev \
    libmpfr-dev \
    libssl-dev \
    libtool \
    libxml2-dev \
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
    uuid-dev \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && ln -sf /usr/include/asm-generic /usr/include/asm

FROM base as osxcross

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
  && OSX_VERSION_MIN=10.10 UNATTENDED=1 ENABLE_COMPILER_RT_INSTALL=1 TARGET_DIR=/usr/local/osxcross ./build.sh

FROM base
COPY --from=osxcross /usr/local/osxcross /usr/local/osxcross
ENV PATH="/usr/local/osxcross/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/osxcross/lib:$LD_LIBRARY_PATH"
RUN curl -sSLk https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver -o /usr/local/bin/semver && chmod +x /usr/local/bin/semver
COPY rootfs /
