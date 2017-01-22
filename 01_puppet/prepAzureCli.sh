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
apt-get -y install nodejs-legacy
apt-get -y install npm
apt-get -y install jq
npm -g install azure-cli

