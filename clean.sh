#!/bin/bash
rm ./aws-cvpne/usr/lib/aws-cvpne/openvpn-v2.6.6-aws.patched || true
rm ./aws-cvpne/usr/lib/aws-cvpne/server-cvpn-sso || true
rm -rf aws-cvpne_0.1.0-beta.deb
rm -rf source/openvpn/
rm -rf source/server-cvpn-sso