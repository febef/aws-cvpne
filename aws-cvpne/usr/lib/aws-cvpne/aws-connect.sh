#!/bin/bash

set -e

#if ([ "$2" != "true" ]); then
#  OUT="/dev/null"
#else
OUT="/var/log/aws-cvpne_$(date +'%Y-%m-%d_%H-%m-%S')_connection.log"
#sudo touch $OUT
#sudo /usr/bin/chmod 777 $OUT
#fi

root="/usr/lib/aws-cvpne"
OVPN_BIN="$root/openvpn-v2.5.2-aws.patched"
PORT=443
PROTO=udp

wait_file() {
  local file="$1"; shift
  local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout
  until test $((wait_seconds--)) -eq 0 -o -f "$file" ; do sleep 1; done
  ((++wait_seconds))
}

# Start sso server
echo "Starting Single-Sing-On Server"
killall server-cvpn-sso &> /dev/null || true
$root/server-cvpn-sso &

# create random hostname prefix for the vpn gw
RAND=$(openssl rand -hex 12)

# resolv manually hostname to IP, as we have to keep persistent ip address
SRV=$(dig a +short "${RAND}.${OVPN_HOST}"|head -n1)

# cleanup
rm -f /usr/lib/aws-cvpne/saml-response.txt

echo "Getting SAML redirect URL from the AUTH_FAILED response (host: ${SRV}:${PORT})"
OVPN_OUT=$($OVPN_BIN --config "${OVPN_CONF}" --verb 3 \
     --proto "$PROTO" --remote "${SRV}" "${PORT}" \
     --auth-user-pass <( printf "%s\n%s\n" "N/A" "ACS::35001" ) \
    2>&1 | grep AUTH_FAILED,CRV1)

echo "Opening browser and wait for the response file..."
URL=$(echo "$OVPN_OUT" | grep -Eo 'https://.+')

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     xdg-open "$URL";;
    Darwin*)    open "$URL";;
    *)          echo "Could not determine 'open' command for this OS"; exit 1;;
esac

wait_file "/usr/lib/aws-cvpne/saml-response.txt" 30 || {
  echo "SAML Authentication time out"
  exit 1
}

# get SID from the reply
VPN_SID=$(echo "$OVPN_OUT" | awk -F : '{print $7}')

# end Single-Sing-On server
echo "Terminating SSO server."
killall server-cvpn-sso &> /dev/null || true

echo "Running OpenVPN with sudo. Enter password if requested"

# Finally OpenVPN with a SAML response we got
# Delete saml-response.txt after connect

DNS_SETUP=""
if [ "$1" != "none" ]; then
  export DNS="$1"
  DNS_SETUP="--down \"$root/remove-DNS.sh '$DNS'\" --up \"$root/add-DNS.sh '$DNS'\"" 
fi

elapsedTime=0

while (( $elapsedTime < 10 )); do
  startTime=$(date +%s)

  sudo bash -c "$OVPN_BIN --config "${OVPN_CONF}" \
    --verb 3 --auth-nocache --inactive 3600 \
    --proto "$PROTO" --remote $SRV $PORT \
    --script-security 2 \
    --route-up '/bin/rm /usr/lib/aws-cvpne/saml-response.txt' \
    --auth-user-pass <( printf \"%s\n%s\n\" \"N/A\" \"CRV1::${VPN_SID}::$(cat /usr/lib/aws-cvpne/saml-response.txt)\" ) \
    $DNS_SETUP"

  elapsedTime="$(($(date +%s) - ${startTime}))"

done