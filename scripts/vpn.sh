export OVPN_DATA=openvpn
export PUB_IP=$(curl https://ipinfo.io/ip)

sudo docker volume create --name $OVPN_DATA

# Server config
sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u tcp://$PUB_IP:443
(echo $PUB_IP) | sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -i kylemanna/openvpn ovpn_initpki nopass

# Start Server
sudo docker run -v $OVPN_DATA:/etc/openvpn -d -p 443:1194/tcp --cap-add=NET_ADMIN kylemanna/openvpn

# Client config
sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full dev nopass
sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient dev > dev.ovpn
