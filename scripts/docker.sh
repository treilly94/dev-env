sudo yum install -y yum-utils \
	device-mapper-persistent-data \
	lvm2

sudo yum-config-manager \
	--add-repo \
	https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce \
	docker-ce-cli \
	containerd.io

sudo systemctl start docker

sudo groupadd docker

sudo usermod -aG docker $USER