#!/bin/bash

rgroupname=$1
numberofnodes=$2


test=$(azure group show $rgroupname | grep "could ot be found")

# Gather stuff needed for keys in template
tmpkey=`echo $(cat ~/.ssh/id_rsa.pub)`
sshKey=$(echo "$tmpkey" | sed 's/\//\\\//g')
clientid=$(cat /etc/puppetlabs/puppet/azure.conf | grep client_id | sed 's/[\"]//g' | sed 's/^.*[:] //')
clientsecret=$(cat /etc/puppetlabs/puppet/azure.conf | grep client_secret | sed 's/[\"]//g' | sed 's/^.*[:] //')
id=$(uuid)

if [ ! -d ~/go ]
then
  mkdir ~/go
fi

if [ -d ~/go/src/github.com/Azure/acs-engine/ ]
then 
  rm -rf ~/go/src/github.com/Azure/acs-engine/
fi

export GOPATH=$HOME/go
go get github.com/Azure/acs-engine
go get all
cd $GOPATH/src/github.com/Azure/acs-engine
go build

cp ~/go/src/github.com/Azure/acs-engine/examples/kubernetes.json /opt/puppet/acs-kube-template.json
cd /opt/puppet
sed -in "s/keyData\": \"\"/keyData\": \"$sshKey\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientID\": \"\"/servicePrincipalClientID\": \"$clientid\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientSecret\": \"\"/servicePrincipalClientSecret\": \"$clientsecret\"/g" acs-kube-template.json
sed -in "s/dnsPrefix\": \"\"/dnsPrefix\": \"a${id}z\"/g" acs-kube-template.json
sed -in "s/\"count\": 3,/\"count\": $numberofnodes,/" acs-kube-template.json

cd ~/go/src/github.com/Azure/acs-engine
./acs-engine /opt/puppet/acs-kube-template.json
cp _output/Kubernetes*/azuredeploy* /opt/puppet/
cd /opt/puppet

azure group create \
    --name=$rgroupname \
    --location="westeurope"

azure group deployment create \
    --name=$id \
    --resource-group="$rgroupname" \
    --template-file="azuredeploy.json" \
    --parameters-file="azuredeploy.parameters.json"

if [ ! -d ~/.kube ]
then
  mkdir ~/.kube 
fi
echo "scp azureuser@a${id}z.westeurope.cloudapp.azure.com:~/.kube/config ~/.kube/config" >~/kube-msg.txt
