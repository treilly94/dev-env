export GITLAB_CONFIG=gitlab_config
export GITLAB_LOGS=gitlab_logs
export GITLAB_DATA=gitlab_data

sudo docker volume create --name $GITLAB_CONFIG
sudo docker volume create --name $GITLAB_LOGS
sudo docker volume create --name $GITLAB_DATA

sudo docker run --detach \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 2222:22 \
  --name gitlab \
  --restart unless-stopped \
  --volume $GITLAB_CONFIG:/etc/gitlab \
  --volume $GITLAB_LOGS:/var/log/gitlab \
  --volume $GITLAB_DATA:/var/opt/gitlab \
  -e "GITLAB_SHELL_SSH_PORT=2222" \
  gitlab/gitlab-ce:latest