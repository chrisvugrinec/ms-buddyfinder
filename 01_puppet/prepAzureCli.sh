#!/bin/sh
#=========================================
#
#       file:   prepAzureCli.sh
#       author: chvugrin@microsoft.com
#       description: installs the stuff needed for azure-cli
#
#=========================================

apt-get update
apt-get -y install git
#apt-get -y install nodejs-legacy
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs
apt-get install -y build-essential
apt-get -y install npm
apt-get -y install jq
npm -g install azure-cli

