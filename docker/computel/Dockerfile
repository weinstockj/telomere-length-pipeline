FROM jweinstk/samtools:latest 

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
        openjdk-8-jre \
        liblzma-dev \
        libbz2-dev

RUN apt-get install -y \
    r-base \
    r-base-dev \
    && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site

WORKDIR /

RUN git clone https://github.com/lilit-nersisyan/computel 

RUN cd /computel && \
    chmod +x computel.sh

ENV PATH ${PATH}:/computel/

ENV SHELL /bin/bash

CMD ["/bin/bash"]
