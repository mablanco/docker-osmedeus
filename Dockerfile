FROM debian:stretch-20190708-slim
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list && \
    echo "deb http://ftp.debian.org/debian/ stretch-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list
WORKDIR /home/Osmedeus
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
RUN apt-get update && \
    apt-get -yu dist-upgrade && \
    apt-get -qq -t stretch-backports install npm && \
    apt-get -qq install locales git sudo wget python3-pip python-pip curl libcurl4-openssl-dev bsdmainutils xsltproc && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    cp -av /usr/bin/pip2 /usr/bin/pip2.7 && \
    git clone --depth 1 https://github.com/j3ssie/Osmedeus . && \
    ./install.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 5000
ENTRYPOINT ["python3", "core/app.py", "-b", "0.0.0.0", "-p", "5000"]
