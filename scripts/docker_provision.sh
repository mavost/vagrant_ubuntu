#!/bin/sh
# REMINDER: no reboot within scripts

echo "... starting docker provision"
# start APT in non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# install Docker with current package
echo "... installing docker"
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y install docker-ce
#not required on ubuntu 20.4
#systemctl enable --now docker
echo "... adding user"
adduser vagrant docker

echo "... installing docker-compose, unzip and git"
#apt-get -y install docker-compose

echo "... starting docker container"
sleep 1

echo "... building image and launching container"
docker run -d -p 8080:80 docker/getting-started

echo "... docker provision completed"












