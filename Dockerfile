FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
        curl \
        ca-certificates \
        xz-utils \
        tar \
        make \
        git \
        sudo

# xPack arm-none-eabi-gcc をダウンロード
RUN mkdir -p /opt/toolchains && \
    cd /opt/toolchains && \
    curl -L https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v15.2.1-1.1/xpack-arm-none-eabi-gcc-15.2.1-1.1-linux-arm64.tar.gz \
    | tar -xz

ENV PATH="/opt/toolchains/xpack-arm-none-eabi-gcc-15.2.1-1.1/bin:${PATH}"

WORKDIR /workspace
