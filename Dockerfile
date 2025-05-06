FROM ubuntu:24.04

# To keep the image as small as possible, don't automatically
# install any suggested or recommended apt packages.
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Prevent apt from prompting us for anything, to allow automated Docker image builds.
ARG DEBIAN_FRONTEND=noninteractive

# Generate an apt package index (cache) so we can install
# packages; it will be deleted later to keep the image small.
RUN apt-get update

# Install all packages required to build Gateway firmware.
RUN apt-get install -y \
    bison \
    build-essential \
    ca-certificates \
    flex \
    git \
    libssl-dev \
    python3 \
    tclsh \
    wget

# Install the Arm aarch64 toolchain. This can be used to cross-compile firmware for the Gateway.
# It is installed in /opt/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu which is
# placed in $PATH. For most packages, it can be selected by setting $CROSS_COMPILE:
#
# export CROSS_COMPILE="aarch64-none-linux-gnu-"
# make ...
RUN mkdir -p /opt \
    && cd /opt \
    && wget https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz \
    && tar xvpf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz \
    && rm -f arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
ENV PATH="$PATH:/opt/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu/bin"

# The "apt-get update" command above generated an apt package index (cache), which is quite large
# and not needed. We remove it here to keep the generated Docker image as small as possible. If
# additional packages need to be installed, the apt cache can be regenerated simply by re-running
# "apt-get update".
RUN rm -rf /var/lib/apt/lists/*
