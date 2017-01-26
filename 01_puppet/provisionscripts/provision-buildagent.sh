#!/bin/bash
password="HelloWorld123!"
apt-get update
apt -y  install docker.io
/usr/sbin/useradd -p `openssl passwd -1 $password` vsts
apt-get install -y libunwind8 libcurl3
apt-get install -y libunwind8 libcurl3 libicu52
# adding user vsts to docker group
usermod -aG docker vsts
