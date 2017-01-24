#!//bin/bash

#az login
azure account show
echo "Enter sub id"
read subscription
sub=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscription")
echo "Resource groupname"
read rgroupname
tmpkey=`echo $(cat ~/.ssh/id_rsa.pub)`
sshKey=$(echo "$tmpkey" | sed 's/\//\\\//g')
clientid=$(echo $sub | jq '.client_id')
clientsecret=$(echo $sub | jq '.client_secret')
id=$(uuid)

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/gopath
go get github.com/Azure/acs-engine 2>/dev/null
go get all
cd $GOPATH/src/github.com/Azure/acs-engine
go build

cp /root/gopath/src/github.com/Azure/acs-engine/examples/kubernetes.json /opt/acs-kube-template.json
cd /opt
sed -in "s/keyData\": \"\"/keyData\": \"$sshKey\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientID\": \"\"/servicePrincipalClientID\": $clientid/g" acs-kube-template.json
sed -in "s/servicePrincipalClientSecret\": \"\"/servicePrincipalClientSecret\": $clientsecret/g" acs-kube-template.json
sed -in "s/dnsPrefix\": \"\"/dnsPrefix\": \"a${id}z\"/g" acs-kube-template.json

cd /root/gopath/src/github.com/Azure/acs-engine
./acs-engine /opt/acs-kube-template.json
cp _output/Kubernetes*/azuredeploy* /opt
cd /opt

azure group create \
    --name=$rgroupname \
    --location="east us"

azure group deployment create \
    --name=$id \
    --resource-group="$rgroupname" \
    --template-file="azuredeploy.json" \
    --parameters-file="azuredeploy.parameters.json"

mkdir ~/.kube 
echo "NOW copy the kube master config to your machine...and you are good to go"
echo "scp azureuser@a${id}z.eastus.cloudapp.azure.com:~/.kube/config ~/.kube/config"
cd /root/microsoft/acs-kubernetes/kube-deploy
