ARG OSX_VERSION="11.1"
ARG OSX_SDK="MacOSX11.1.sdk"
ARG OSX_SDK_PATH="https://github.com/larskanis/MacOSX-SDKs/releases/download/${OSX_VERSION}/${OSX_SDK}.tar.xz"
ARG OSX_SDK_SUM="cba4eb0add14db320cd63bd0fc9c1ffb9ef236c1"
ARG OSX_CROSS_COMMIT="035cc170338b7b252e3f13b0e3ccbf4411bffc41"
ARG CC_CXX_VERSION="8"

FROM debian:buster
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
  && find /var/log -type f | while read f; do echo -ne '' > $f; done;

ENV XGO_IN_XGO="1"\
  PATH="/usr/local/go/bin:$PATH" \
  GOPATH="/go" \
  GOCACHE="/go-build"

# Fix any stock package issues
RUN ln -s /usr/include/asm-generic /usr/include/asm

# Add patches directory for patching later
ADD docker/base/patches /patches

# Fetch helper
ADD docker/base/fetch.sh /fetch.sh
ENV FETCH /fetch.sh
RUN chmod +x $FETCH

# Download the osx sdk and build the osx toolchain
# We download the osx sdk, patch it and pack it again to be able to throw the patched version at osxcross
ARG OSX_VERSION
ARG OSX_SDK
ARG OSX_SDK_PATH
ARG OSX_SDK_SUM
RUN $FETCH $OSX_SDK_PATH $OSX_SDK_SUM \
  && tar -xf `basename $OSX_SDK_PATH` \
  && rm -f `basename $OSX_SDK_PATH`
ADD docker/base/patch.tar.xz "$OSX_SDK/usr/include/c++"
RUN tar -cf - $OSX_SDK/ | xz -c - > $OSX_SDK.tar.xz \
  && rm -rf $OSX_SDK

# Actually build the toolchain
ENV LD_LIBRARY_PATH="/osxcross/target/lib"
ARG OSX_CROSS_COMMIT
RUN git clone https://github.com/tpoechtrager/osxcross.git \
  && cd osxcross \
  && git reset --hard $OSX_CROSS_COMMIT \
  && cd ../ \
  && mv $OSX_SDK.tar.xz /osxcross/tarballs/ \
  && OSX_VERSION_MIN=10.10 UNATTENDED=1 LD_LIBRARY_PATH=${LD_LIBRARY_PATH} /osxcross/build.sh
ENV PATH="/osxcross/target/bin:$PATH"

# Inject the new Go root distribution downloader and bootstrapper
ADD docker/base/bootstrap_pure.sh /bootstrap_pure.sh
ENV BOOTSTRAP_PURE="/bootstrap_pure.sh"
RUN chmod +x $BOOTSTRAP_PURE

# Copy xgo sources within the container to enable internal cross compilation
ADD go.mod /usr/local/src/xgo/go.mod
ADD xgo.go /usr/local/src/xgo/xgo.go

# Inject the C dependency cross compiler
ADD docker/base/build_deps.sh /build_deps.sh
ENV BUILD_DEPS /build_deps.sh
RUN chmod +x $BUILD_DEPS

# Inject the container entry point, the build script
ADD docker/base/build.sh /build.sh
ENV BUILD /build.sh
RUN chmod +x $BUILD

ARG CC_CXX_VERSION
ENV CC_CXX_VERSION=${CC_CXX_VERSION}
ENTRYPOINT [ "/build.sh" ]
