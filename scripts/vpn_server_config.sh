#!/usr/bin/expect
set OVPN_DATA openvpn

spawn sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
expect "Enter New CA Key Passphrase:"
send -- "8V7bshRtXuqsBN7u\n"
expect "Re-Enter New CA Key Passphrase:"
send -- "8V7bshRtXuqsBN7u\n"
expect "Common Name (eg: your user, host, or server name) [Easy-RSA CA]:"
send -- "$PUB_IP\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key:"
send -- "8V7bshRtXuqsBN7u\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key:"
send -- "8V7bshRtXuqsBN7u\n"