FROM kalilinux/kali-rolling@sha256:b1f67719a6d2c62f08ceadaebf2daf64a32cb56b5dbf5c6307ac48cd84cda3d4
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/osmedeus-base/external-binaries:/root/.local/bin:${PATH}"
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
RUN apt-get update && \
    apt-get -yq install \
        apt-utils \
        locales \
        curl \
        git \
        rsync \
        massdns \
        assetfinder && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    apt-get -yqu dist-upgrade && \
    bash -c "$(curl -sSL http://www.osmedeus.org/install.sh)" && \
    osmedeus install base --preset && \
    osmedeus health && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
WORKDIR /root
EXPOSE 8000
CMD ["osmedeus"]
