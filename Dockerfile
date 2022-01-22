FROM debian:bullseye-20211220-slim
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
RUN apt-get update && \
    apt-get -yq install apt-utils locales curl && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    apt-get -yqu dist-upgrade && \
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install.sh)" && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    curl -LO https://releases.hashicorp.com/packer/1.7.9/packer_1.7.9_linux_amd64.zip && \
    unzip packer_1.7.9_linux_amd64.zip && \
    mv -v packer /root/osmedeus-base/binaries/ && \
    rm packer_1.7.9_linux_amd64.zip
WORKDIR /root
EXPOSE 8000
CMD ["osmedeus"]
