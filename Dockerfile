FROM kalilinux/kali-rolling@sha256:343d384008ad4595e1466aa5e6c84f23b77386d229fc3680c28deaf8d1150dbe
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
RUN apt-get update && \
    apt-get -yq install \
        apt-utils \
        locales \
        curl \
        wget \
        unzip \
        git \
        rsync \
        massdns \
        assetfinder && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    apt-get -yqu dist-upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    useradd -m -s /bin/bash osmedeus
USER osmedeus
ENV PATH="/home/osmedeus/osmedeus-base/external-binaries:/home/osmedeus/.local/bin:${PATH}"
RUN bash -c "$(curl -sSL http://www.osmedeus.org/install.sh)" && \
    osmedeus install base --preset && \
    osmedeus health
WORKDIR /home/osmedeus
EXPOSE 8002
CMD ["osmedeus"]
