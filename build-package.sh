#!/bin/bash

#docker rmi openvpn-compiler
rm ./aws-cvpne/usr/lib/aws-cvpne/openvpn-v2.6.6-aws.patched || true
rm ./aws-cvpne/usr/lib/aws-cvpne/server-cvpn-sso || true

docker build . -f Dockerfile -t openvpn-compiler
DIR=$(pwd | sed 's;/local;;g;');
 echo $DIR
docker run -v "$DIR":/pkg openvpn-compiler bash -c 'cd /pkg/source && ./build-openvpn.sh'

cp -f ./source/openvpn/openvpn-2.6.6/src/openvpn/openvpn ./aws-cvpne/usr/lib/aws-cvpne/openvpn-v2.6.6-aws.patched
cp -f ./source/server-cvpn-sso ./aws-cvpne/usr/lib/aws-cvpne/server-cvpn-sso

dpkg-deb --build aws-cvpne

mv aws-cvpne.deb aws-cvpne_0.1.0-beta.deb