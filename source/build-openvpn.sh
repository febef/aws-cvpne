#/bin/bash
rm -rf openvpn || true
rm server-cvpn-sso || true

mkdir -p openvpn

cd openvpn

wget https://swupdate.openvpn.org/community/releases/openvpn-2.5.2.tar.gz
tar xzvf openvpn-2.5.2.tar.gz > /dev/null

cd openvpn-2.5.2

git init .
git apply ../../openvpn-v2.5.2-aws.patch 

./configure && make 

cd ../../

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export PATH="$HOME/bin:/c/MinGW/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="/root/.go"

export LANG=en_US.UTF-8

go build server-cvpn-sso.go
chmod +x server-cvpn-sso