#!/bin/sh
#=========================================
#
#       file:  configPuppet.sh 
#       author: chvugrin@microsoft.com
#       description: creates the puppet config file 
#                    so your puppet can use the azure module                    
#                    /etc/puppetlabs/puppet/azure.conf  will be created 
#
#=========================================

if [ "$#" -ne 1 ]
then
  echo "provide app as parameter"
  exit 1
fi

app=$1 

# Stuff needed for tooling
#apt-get update
#apt-get -y install git
#apt-get -y install nodejs-legacy
#apt-get -y install npm
#apt-get -y install jq
#npm -g install azure-cli

# Stuff needed for azure puppet module

/opt/puppetlabs/puppet/bin/gem install retries --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install azure --version='~>0.7.0' --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install azure_mgmt_compute --version='~>0.3.0' --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install azure_mgmt_storage --version='~>0.3.0' --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install azure_mgmt_resources --version='~>0.3.0' --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install azure_mgmt_network --version='~>0.3.0' --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install hocon --version='~>1.1.2' --no-ri --no-rdoc
puppet module install puppetlabs-azure

# getting the script sources for config

#exit 0
#git clone https://github.com/chrisvugrinec/ms-buddyfinder.git


./loginToAzure.sh
azureconf="/etc/puppetlabs/puppet/azure.conf"

subscriptionid=$(azure account show --json | jq -r  '.[].id')
tenantid=$(azure account show --json | jq -r  '.[].tenantId')
clientid=$(azure account show --json | jq -r  '.[].user.name')

echo "azure: {\n subscription_id: \"$subscriptionid\" \n tenant_id: \"$tenantid\" \n client_id: \"$clientid\" \n client_secret: \"LOOKUP SECRET\" \n }" >$azureconf
echo "written conf to "$azureconf
echo "you need to load the ENV variables and create a KEY in the console for your app principal named: "$app
echo "this key needs to be copied in the "$azureconf" file"
