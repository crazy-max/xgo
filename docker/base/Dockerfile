FROM debian:stretch

ENV XGO_IN_XGO="1"\
  DEBIAN_FRONTEND="noninteractive" \
  PATH="/usr/local/go/bin:$PATH" \
  GOPATH="/go" \
  GOCACHE="/go-build"

ADD fetch.sh /fetch.sh
ENV FETCH /fetch.sh
RUN chmod +x $FETCH

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
    g++-*-aarch64-linux-gnu \
    g++-*-arm-linux-gnueabi \
    g++-*-arm-linux-gnueabihf \
    g++-*-mips-linux-gnu \
    g++-*-mipsel-linux-gnu \
    g++-*-mips64-linux-gnuabi64 \
    g++-*-mips64el-linux-gnuabi64 \
    g++-*-multilib \
    g++-mingw-w64 \
    gcc-*-aarch64-linux-gnu \
    gcc-*-arm-linux-gnueabi \
    gcc-*-arm-linux-gnueabihf \
    gcc-*-mips-linux-gnu \
    gcc-*-mipsel-linux-gnu \
    gcc-*-mips64-linux-gnuabi64 \
    gcc-*-mips64el-linux-gnuabi64 \
    gcc-*-multilib \
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
    libssl-dev \
    libtool \
    libxml2-dev \
    llvm-dev \
    lzma-dev \
    make \
    mercurial \
    openjdk-8-jdk \
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
  && find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Fix any stock package issues
RUN ln -s /usr/include/asm-generic /usr/include/asm

# Add patches directory for patching later
ADD patches /patches

# Configure the container for OSX cross compilation and make libxar known to the ld64 and cctools build
ENV LD_LIBRARY_PATH="/osxcross/target/lib" \
  OSX_SDK="MacOSX10.11.sdk"
ENV OSX_SDK_PATH="https://s3.dockerproject.org/darwin/v2/$OSX_SDK.tar.xz" \
  OSX_SDK_SUM="dd228a335194e3392f1904ce49aff1b1da26ca62" \
  OSX_CROSS_COMMIT="88cb6e8d0d7675cae7c8a2d66c11f58237101df0"

# Download the osx sdk and build the osx toolchain
# We download the osx sdk, patch it and pack it again to be able to throw the patched version at osxcross
RUN $FETCH $OSX_SDK_PATH $OSX_SDK_SUM \
  && tar -xf `basename $OSX_SDK_PATH` \
  && rm -f `basename $OSX_SDK_PATH`
ADD patch.tar.xz "$OSX_SDK/usr/include/c++"
RUN tar -cf - $OSX_SDK/ | xz -c - > $OSX_SDK.tar.xz \
  && rm -rf $OSX_SDK

# Actually build the toolchain
RUN git clone https://github.com/tpoechtrager/osxcross.git \
  && cd osxcross \
  && git checkout $OSX_CROSS_COMMIT \
  && cd ../ \
  && mv  $OSX_SDK.tar.xz /osxcross/tarballs/ \
  && OSX_VERSION_MIN=10.10 UNATTENDED=1 LD_LIBRARY_PATH=/osxcross/target/lib /osxcross/build.sh

ENV PATH /osxcross/target/bin:$PATH

# Inject the new Go root distribution downloader and bootstrapper
ADD bootstrap_pure.sh /bootstrap_pure.sh
ENV BOOTSTRAP_PURE /bootstrap_pure.sh
RUN chmod +x $BOOTSTRAP_PURE

# Inject the C dependency cross compiler
ADD build_deps.sh /build_deps.sh
ENV BUILD_DEPS /build_deps.sh
RUN chmod +x $BUILD_DEPS

# Inject the container entry point, the build script
ADD build.sh /build.sh
ENV BUILD /build.sh
RUN chmod +x $BUILD

ENV CC_CXX_VERSION="6"
ENTRYPOINT [ "/build.sh" ]
