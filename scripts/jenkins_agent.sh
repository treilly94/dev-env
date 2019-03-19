sudo yum install -y java-1.8.0-openjdk

# Add jenkins user
sudo adduser jenkins
(echo leeroy; echo leeroy) | sudo passwd jenkins

# Add jenkins user to the docker group
sudo usermod -aG docker jenkins