FROM debian:trixie-20260112-slim
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/osmedeus-base/external-binaries:/root/.local/bin:${PATH}"
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get -yq install apt-utils locales curl git rsync && \
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
