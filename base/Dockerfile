ARG CC_CXX_VERSION="8"
ARG OSX_SDK="MacOSX11.1.sdk"
ARG OSX_SDK_URL="https://github.com/larskanis/MacOSX-SDKs/releases/download/11.1/${OSX_SDK}.tar.xz"
ARG OSX_CROSS_COMMIT="035cc170338b7b252e3f13b0e3ccbf4411bffc41"

FROM debian:buster AS base
ARG CC_CXX_VERSION
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    autogen \
    automake \
    bash \
    build-essential \
    bzr \
    ca-certificates \
    clang \
    cmake \
    cpio \
    curl \
    g++-${CC_CXX_VERSION}-aarch64-linux-gnu \
    g++-${CC_CXX_VERSION}-arm-linux-gnueabi \
    g++-${CC_CXX_VERSION}-arm-linux-gnueabihf \
    g++-${CC_CXX_VERSION}-mips-linux-gnu \
    g++-${CC_CXX_VERSION}-mipsel-linux-gnu \
    g++-${CC_CXX_VERSION}-mips64-linux-gnuabi64 \
    g++-${CC_CXX_VERSION}-mips64el-linux-gnuabi64 \
    g++-${CC_CXX_VERSION}-multilib \
    g++-${CC_CXX_VERSION}-powerpc64le-linux-gnu \
    g++-${CC_CXX_VERSION}-s390x-linux-gnu \
    g++-mingw-w64 \
    gcc-${CC_CXX_VERSION}-aarch64-linux-gnu \
    gcc-${CC_CXX_VERSION}-arm-linux-gnueabi \
    gcc-${CC_CXX_VERSION}-arm-linux-gnueabihf \
    gcc-${CC_CXX_VERSION}-mips-linux-gnu \
    gcc-${CC_CXX_VERSION}-mipsel-linux-gnu \
    gcc-${CC_CXX_VERSION}-mips64-linux-gnuabi64 \
    gcc-${CC_CXX_VERSION}-mips64el-linux-gnuabi64 \
    gcc-${CC_CXX_VERSION}-multilib \
    gcc-${CC_CXX_VERSION}-powerpc64le-linux-gnu \
    gcc-${CC_CXX_VERSION}-s390x-linux-gnu \
    gcc-mingw-w64 \
    git \
    help2man \
    libc*-dev-arm64-cross \
    libc*-dev-armel-cross \
    libc*-dev-armhf-cross \
    libc*-dev-mips-cross \
    libc*-dev-mipsel-cross \
    libc*-dev-mips64-cross \
    libc*-dev-mips64el-cross \
    libc*-dev-ppc64el-cross \
    libc*-dev-s390x-cross \
    libssl-dev \
    libtool \
    libxml2-dev \
    llvm-dev \
    lzma-dev \
    make \
    mercurial \
    openjdk-11-jdk \
    p7zip \
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
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && ln -s /usr/include/asm-generic /usr/include/asm \
  && find /var/log -type f | while read f; do echo -ne '' > $f; done;

FROM base AS osx
ARG OSX_VERSION
ARG OSX_SDK
ARG OSX_SDK_URL
RUN wget -q $OSX_SDK_URL \
  && tar -xf $(basename $OSX_SDK_URL) \
  && rm -f $(basename $OSX_SDK_URL)
ADD patch.tar.xz "$OSX_SDK/usr/include/c++"
RUN tar -cf - $OSX_SDK/ | xz -c - > $OSX_SDK.tar.xz \
  && rm -rf $OSX_SDK

ENV LD_LIBRARY_PATH="/osxcross/target/lib"
ARG OSX_CROSS_COMMIT
RUN git clone https://github.com/tpoechtrager/osxcross.git \
  && cd osxcross \
  && git reset --hard $OSX_CROSS_COMMIT \
  && cd ../ \
  && mv $OSX_SDK.tar.xz /osxcross/tarballs/ \
  && OSX_VERSION_MIN=10.10 UNATTENDED=1 LD_LIBRARY_PATH=${LD_LIBRARY_PATH} /osxcross/build.sh
ENV PATH="/osxcross/target/bin:$PATH"

FROM osx
ENV XGO_IN_XGO="1"\
  PATH="/usr/local/go/bin:$PATH" \
  GOPATH="/go" \
  GOCACHE="/go-build"
COPY rootfs /

ARG CC_CXX_VERSION
ENV CC_CXX_VERSION=${CC_CXX_VERSION}
ENTRYPOINT [ "xgo-build" ]
