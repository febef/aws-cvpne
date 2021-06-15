#!/bin/bash
echo "$(date +'%Y-%m-%d %H:%m:%S') Setting-up-dns to $DNS"

grep "nameserver $DNS" /etc/resolv.conf > /dev/null

if [ "$?" != "0" ]; then
  echo -e "nameserver $DNS\n$(cat /etc/resolv.conf)" > /etc/resolv.conf
fi