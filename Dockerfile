# newtonsystems/tools/docker-grpc-tools
#
#
# A Docker Image for generating grpc service for multiple languages
#
# Please README.md for how to run this Docker Container
#
# To be used with circleci for ci:
#     This docker image must be PUBLIC: 

From debian:jessie
MAINTAINER James Tarball <james.tarball@newtonsystems.co.uk>

# Add Label Badges to Dockerfile powered by microbadger
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/microscaling/microscaling" 

# Packages
RUN apt-get -yq update && apt-get -yq install \
    build-essential autoconf libtool \
    git \
    curl \
    python-dev \
    python \
    python-pip \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install grpc (should install protoc as well)
# Install Proto Buffer version 3
# NOTE: We select the latest release (potentially risky but oh well...)
RUN git clone -b $(curl -L http://grpc.io/release) https://github.com/grpc/grpc /tmp/grpc && \
    cd /tmp/grpc && \
    git submodule update --init && \
    make && \
    make install && make clean && \
    cd /tmp/grpc/third_party/protobuf && \
    make && make install && make clean && \
    rm -rf /tmp/grpc

# Basic check
RUN protoc --version

RUN pip install grpcio-tools devpi-client

CMD ["/bin/bash"]
