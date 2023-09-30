FROM debian:testing                                                                                                                                                                                          

ENV DEBIAN_FRONTEND=noninteractive
RUN echo LANG="en_US.UTF-8" > /etc/default/locale 

RUN apt update ; apt upgrade -y;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    curl tree wget;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    build-essential cmake make gcc-13 gcc-13-base g++ git;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    gnupg software-properties-common  ;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install \
    openssh-client openssl;

RUN wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz ;\
    tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz ;

RUN apt-get --no-install-recommends --no-install-suggests -y -qq install lz4 liblz4-dev liblzo2-2 liblzo2-dev libpam-runtime libpam0g-dev libssl-dev libnl-genl-3-dev pkg-config libcap-ng-dev