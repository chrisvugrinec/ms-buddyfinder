#!/bin/bash
password="HelloWorld123!"
apt-get update
apt -y  install docker.io
/usr/sbin/useradd -p `openssl passwd -1 $password` vsts
# adding user vsts to docker group
usermod -aG docker vsts
