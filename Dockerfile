FROM golang:1.27.4-bookworm AS go-tools
RUN apt-get update && \
    apt-get -yq install --no-install-recommends jq && \
    rm -rf /var/lib/apt/lists/*
COPY build/ /build/
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    /build/build-go-tools.sh /build/go-tools.txt /out/external-binaries && \
    mkdir -p /out/bin && \
    mv /out/external-binaries/osmedeus /out/external-binaries/assetfinder /out/bin/

FROM kalilinux/kali-rolling@sha256:1ff4a2be3849333687b3ed2b31bb5af0cd1b7c0a11ec7713feb5abe5a6b2795c
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
        jq \
        trivy \
        massdns && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    apt-get -yqu dist-upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash osmedeus
USER osmedeus
ENV PATH="/home/osmedeus/osmedeus-base/external-binaries:/home/osmedeus/.local/bin:${PATH}"
COPY --from=go-tools /out/bin/assetfinder /usr/local/bin/assetfinder
# Replace the upstream prebuilt binaries with the ones rebuilt from source,
# in the same layer so the originals do not linger in the image
RUN --mount=type=bind,from=go-tools,source=/out,target=/tmp/go-tools \
    bash -c "$(curl -sSL https://www.osmedeus.org/install.sh)" && \
    osmedeus install base --preset && \
    cp -f /tmp/go-tools/bin/osmedeus /home/osmedeus/.local/bin/osmedeus && \
    cp -f /tmp/go-tools/external-binaries/* /home/osmedeus/osmedeus-base/external-binaries/ && \
    ln -sf /usr/bin/jq /home/osmedeus/osmedeus-base/external-binaries/jq && \
    osmedeus health
WORKDIR /home/osmedeus
EXPOSE 8002
CMD ["osmedeus"]
