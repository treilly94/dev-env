export JENKINS_DATA=jenkins

sudo docker volume create --name $JENKINS_DATA

sudo docker run -p 80:8080 -p 50000:50000 -d --restart unless-stopped -v $JENKINS_DATA:/var/jenkins_home jenkins/jenkins:lts