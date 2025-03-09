#!/bin/bash

#   **********************************************************  #
#   #Author :   Ajay Chaudhary
#   #Date   :   03/08/2025
#   #Purpose:   Installing JENKINS in DOCKER
#   #Source :   https://www.jenkins.io/doc/book/installing/docker/
#   **********************************************************  #

# set -x

#   1.  Create a bridge network in Docker using the following docker network create command:
echo "Step#1 : Creating bridge network in Docker by executing  - docker network create jenkins"
docker network create jenkins

#   2.  In order to execute Docker commands inside Jenkins nodes, download and run the docker:dind Docker image using the following docker run command:
echo "Step#2  : For running Docker commands inside Jenkins nodes, download and run the docker:dind Docker image"
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2

echo  "Step#3 : Customizing the Jenkins docker image.."
echo  "Step#3.1 :  We should have a Dockerfile created"
#   3.1 Customize the official Jenkins Docker image, by executing the following two steps:
#     #a. Create a Dockerfile with the following content:
#        FROM jenkins/jenkins:2.492.2-jdk17
#        USER root
#        RUN apt-get update && apt-get install -y lsb-release
#        RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
#          https://download.docker.com/linux/debian/gpg
#        RUN echo "deb [arch=$(dpkg --print-architecture) \
#          signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
#          https://download.docker.com/linux/debian \
#          $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
#        RUN apt-get update && apt-get install -y docker-ce-cli
#       USER jenkins
#        RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

#     #b. Build a new docker image from this Dockerfile, and assign the image a meaningful name, such as "myjenkins-blueocean:2.492.2-1":
echo  "Step#3.2 :  Build a new image say aj_own_jenkins from the provided Dockerfile"
docker build -t aj_own_jenkins:2.492.2-1 .

# Step-4  Run your own aj_own_jenkins:2.492.2-1 image as a container in Docker using the following docker run command:
echo "Step#4  Run the previously created customized image using docker run command:"
docker run \
  --name aj_own_jenkins \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  aj_own_jenkins:2.492.2-1

# Step# 5 - Validate if Jenkins is up and running
echo  "Step# 5 : Lets start running Jenkins..."
echo  "User should open up web browser and execute http://localhost:8080/"

# Step# 6 - Since we are starting the Jenkins first time, it will prompt for initial admin password"
echo "Step# 6 - First use requires providing initialAdminPassword..let's try locating it"
echo  "Since we are running Jenkins inside DOCKER container so we have to go inside bash shell of container to fetch the data"
echo  " Executing command - docker container exec -it aj_own_jenkins bash"

docker container exec -it aj_own_jenkins bash

# Step# 7 - Printing the initial admin password here:
echo "Step#7 - Getting the initial admin password by executing sudo cat /var/lib/jenkins/secrets/initialAdminPassword "
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 

# Script ends...........
echo "We are done, happy using Jenkins using localhost:8080/"
