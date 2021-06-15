FROM debian:testing                                                                                                                                                                                          

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update ; apt upgrade -y;
RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    curl tree wget;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    build-essential cmake make gcc-10 gcc-10-base g++-10 git;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    gnupg software-properties-common  ;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    openssh-client;

RUN wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz ;\
    tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz ;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install lz4 liblz4-dev liblzo2-2 liblzo2-dev libpam-runtime libpam0g-dev