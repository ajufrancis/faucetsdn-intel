#!/bin/sh
## @author: Shivaram.Mysore@gmail.com

## Check if user is root
if [ "$EUID" -ne 0 ]
    then echo "Run $0 script as root after a fresh install of Ubuntu 16.10"
    exit
fi


# name of the user to be added to docker group; Assume user "bird" is already created.
USER_LIST=bird

apt-get update

apt-get install software-properties-common git wget curl unzip bzip2 screen minicom make gcc dpdk dpdk-dev dpdk-doc dpdk-igb-uio-dkms openvswitch-common openvswitch-switch openvswitch-switch-dpdk python-openvswitch openvswitch-pki openvswitch-testcontroller python2.7 libpython2.7 python-pip linux-image-extra-$(uname -r) linux-image-extra-virtual apt-transport-https ca-certificates

## Optionally add sensors package for finding out temperature
apt-get install hwinfo lm-sensors  hddtemp
service kmod start
sensors-detect --auto
sensors
hddtemp /dev/sda  

# Add Docker’s official GPG key
curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

# Verify that the docker key ID is 58118E89F3A912897C070ADBF76221572C52609D
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

# Add stable Docker repo
add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"

echo "Disable testing repository: edit /etc/apt/sources.list and remove the word testing from the appropriate line in the file."

# Per https://www.linuxbabe.com/docker/install-docker-ubuntu-16-10-yakkety-yak
apt install docker.io

usermod -aG docker $USER_LIST

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> /etc/apt/sources.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

apt update
apt install docker-engine

systemctl enable docker

echo "Docker version: "
docker -v

echo ""
echo "System-wide information regarding the Docker installation ...\n"
docker info

echo "Testing Docker installation ..."
docker run hello-world

