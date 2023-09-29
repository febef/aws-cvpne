#/bin/bash
rm -rf openvpn server-cvpn-sso || true

mkdir -p openvpn

cd openvpn



#wget https://swupdate.openvpn.org/community/releases/openvpn-2.5.2.tar.gz
#tar xzvf openvpn-2.5.2.tar.gz > /dev/null
wget https://github.com/OpenVPN/openvpn/archive/refs/tags/v2.6.6.tar.gz



cd openvpn-2.6.6

git init .
git apply ../../openvpn-v2.6.6-aws.patch 

./configure && make 

cd ../../

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export PATH="$HOME/bin:/c/MinGW/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="/root/.go"

export LANG=en_US.UTF-8

go build server-cvpn-sso.go
chmod +x server-cvpn-sso