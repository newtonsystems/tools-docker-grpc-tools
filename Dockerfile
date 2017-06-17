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

# Install Latest Docker
RUN apt-get -yq update && apt-get -yq install \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \ 
    $(lsb_release -cs) \
    stable"

RUN apt-get -yq update && apt-get -yq install docker-ce

# Install kube-ctl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl


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
