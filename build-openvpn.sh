#/bin/bash -x 
root=`pwd`

mkdir -p openvpn

cd openvpn

wget https://swupdate.openvpn.org/community/releases/openvpn-2.5.2.tar.gz

tar xzvf openvpn-2.5.2.tar.gz

cd openvpn-2.5.2

git init .

git apply ../../openvpn-v2.5.2-aws.patch 

./configure && make

cp ./src/openvpn/openvpn ../openvpn-2.5.2-patch

cd $root

go build server-cvpn-sso.go
chmod +x server-cvpn-sso
