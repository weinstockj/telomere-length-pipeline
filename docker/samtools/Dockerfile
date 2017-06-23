
FROM ubuntu:16.04

LABEL maintainer "Josh Weinstock <jweinstk@umich.edu>"

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get -y install \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        ca-certificates \
        gcc \
        make \
        libpq-dev \
        ssh \
        git \
        apt-transport-https \
        liblzma-dev \
        libbz2-dev


ADD https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2 /
ADD https://github.com/samtools/htslib/releases/download/1.4.1/htslib-1.4.1.tar.bz2 /

RUN tar xvjf /samtools-1.4.1.tar.bz2 && \
    cd /samtools-1.4.1 && \
    make && \
    make install 

RUN tar xvjf /htslib-1.4.1.tar.bz2 && \
    cd /htslib-1.4.1 && \
    make && \
    make install 

WORKDIR /opt/

ENV PATH ${PATH}:/opt/svtoolkit/:/samtools-1.4.1/bin:/htslib-1.4.1/bin

ENV SHELL /bin/bash

CMD ["/bin/bash"]
