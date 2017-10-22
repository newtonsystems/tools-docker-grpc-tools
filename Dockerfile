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

# Add Mongo Repo Key
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Packages
RUN apt-get -yq update && apt-get -yq install \
    build-essential autoconf libtool \
    git \
    curl \
    python-dev \
    python \
    python-pip \
    mongodb-org \
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
RUN mv ./kubectl /usr/local/bin/kubectl


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

# Install go
RUN curl -O https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz

# Add to go path
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH /usr/local/go/bin:$GOPATH/bin:/usr/local/bin:$PATH

# Install protoc-gen-go
RUN go get -u github.com/golang/protobuf/protoc-gen-go

# Basic check
RUN protoc --version

RUN pip install grpcio-tools devpi-client

CMD ["/bin/bash"]
