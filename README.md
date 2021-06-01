# aws-vpn-client

This is PoC to connect to the AWS Client VPN with OSS OpenVPN using SAML
authentication. Tested on macOS and Linux, should also work on other POSIX OS with a minor changes.

See [blog post](https://smallhacks.wordpress.com/2020/07/08/aws-client-vpn-internals/) for the implementation details.

## Content of the repository

- [openvpn-v2.4.9-aws.patch](openvpn-v2.4.9-aws.patch) - patch required to build
AWS compatible OpenVPN v2.4.9, based on the
[AWS source code](https://amazon-source-code-downloads.s3.amazonaws.com/aws/clientvpn/osx-v1.2.5/openvpn-2.4.5-aws-2.tar.gz) (thanks to @heprotecbuthealsoattac) for the link.
- [server.go](server.go) - Go server to listed on http://127.0.0.1:35001 and save
SAML Post data to the file
- [aws-connect.sh](aws-connect.sh) - bash wrapper to run OpenVPN. It runs OpenVPN first time to get SAML Redirect and open browser and second time with actual SAML response

+++++
- The patch for version 2.5.2 was added, which is the same as 2.5.1, and a script to compile this last version, and the sso server.
- The aws-connect script was also modified so that it raises the sso server and kills it when it is finished using it.
- Finally, the port was modified to 443 since it is the one that worked in my config and a file '.env' was displayed for the id of the aws client endpoint vpn

+++++
## How to use

1. Build: Run [build-openvpn.sh](build-openvpn.sh)
1. Configure:
     1. Setup your `.env` with your `CVPN_ID` as ref [.env.example](.env.example)
     1. Add your `vpn.conf` as ref [vpn.conf.example](vpn.conf.example)
     1. Add the [aws.cacert](aws.cacert) first to <ca> section on your `vpn.conf`
1. Connect: Run [aws-connect.sh](aws-connect.sh)

### the old way
1. Build patched openvpn version and put it to the folder with a script
1. Start HTTP server with `go run server.go`
1. Set VPN_HOST in the [aws-connect.sh](aws-connect.sh)
1. Replace CA section in the sample [vpn.conf](vpn.conf) with one from your AWS configuration
1. Finally run `aws-connect.sh` to connect to the AWS.

### Additional Steps

Inspect your ovpn config and remove the following lines if present
- `auth-user-pass` (we dont want to show user prompt)
- `auth-federate` (propietary AWS keyword)
- `auth-retry interact` 
- `resolv-retry infinite` (do not retry on failures)
- `remote` and `remote-random-hostname` (already handled in CLI and can cause conflicts with it)

## Todo

Better integrate SAML HTTP server with a script or rewrite everything on golang
