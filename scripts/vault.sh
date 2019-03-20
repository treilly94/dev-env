# Download valt zip
sudo curl https://releases.hashicorp.com/vault/1.1.0/vault_1.1.0_linux_amd64.zip --output /vault.zip

# Unzip into bin
sudo yum install -y unzip
sudo unzip /vault.zip -d /bin/

# Remove zip
sudo rm /vault.zip