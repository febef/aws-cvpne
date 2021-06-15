#!/bin/bash

podman rmi openvpn-compiler
rm ./aws-cvpne/usr/lib/aws-cvpne/openvpn-v2.5.2-aws.patch || true
rm ./aws-cvpne/usr/lib/aws-cvpne/server-cvpn-sso || true

podman build . -f Dockerfile -t openvpn-compiler
podman run -v ./:/pkg openvpn-compiler bash -c 'cd /pkg/source && ./build-openvpn.sh'

cp -f ./source/openvpn/openvpn-2.5.2/src/openvpn/openvpn ./aws-cvpne/usr/lib/aws-cvpne/openvpn-v2.5.2-aws.patch
cp -f ./source/server-cvpn-sso ./aws-cvpne/usr/lib/aws-cvpne/server-cvpn-sso

dpkg-deb --build aws-cvpne

mv aws-cvpne.deb aws-cvpne_0.1.0-beta.deb