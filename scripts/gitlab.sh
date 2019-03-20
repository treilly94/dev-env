export GITLAB_CONFIG=gitlab_config
export GITLAB_LOGS=gitlab_logs
export GITLAB_DATA=gitlab_data

sudo docker volume create --name $GITLAB_CONFIG
sudo docker volume create --name $GITLAB_LOGS
sudo docker volume create --name $GITLAB_DATA

sudo docker run --detach \
  --hostname gitlab.example.com \
  -p 443:443 -p 80:80 -p 2222:22 \
  --name gitlab \
  --restart unless-stopped \
  -v $GITLAB_CONFIG:/etc/gitlab \
  -v $GITLAB_LOGS:/var/log/gitlab \
  -v $GITLAB_DATA:/var/opt/gitlab \
  gitlab/gitlab-ce:latest