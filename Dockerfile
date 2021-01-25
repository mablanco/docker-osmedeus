FROM debian:buster-20210111-slim
ENV DEBIAN_FRONTEND noninteractive
ARG OSMEDEUS_VERSION=v2.2
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list
WORKDIR /home/Osmedeus
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
RUN apt-get update && \
    apt-get -yq install apt-utils locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    apt-get -yqu dist-upgrade && \
    apt-get -yq install \
      npm \
      git \
      sudo \
      wget \
      python3-pip \
      python-pip \
      curl \
      libcurl4-openssl-dev \
      bsdmainutils \
      xsltproc && \
    git clone --depth 1 https://github.com/j3ssie/Osmedeus -b $OSMEDEUS_VERSION . && \
    ./install.sh && \
    /root/.go/bin/go get -u github.com/tomnomnom/unfurl && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
EXPOSE 8000
CMD ["python3 osmedeus.py"]
