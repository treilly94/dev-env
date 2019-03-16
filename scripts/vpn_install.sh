export OVPN_DATA=openvpn
export PUB_IP=$(curl https://ipinfo.io/ip)

sudo docker volume create --name $OVPN_DATA

sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://$PUB_IP
