#!/bin/bash
app=$1
buildid=$2
dockerreg=$3
sed -in 's/XXX_DOCKERREG_XXX/'$dockerreg'/' $app.yaml
sed -in 's/XXX_APP_XXX/'$app'/' $app.yaml
sed -in 's/XXX_BUILD_XXX/'$buildid'/' $app.yaml
# check if pod exists..if exists do a kubectl rolling-update 
if [[ $(kubectl get pods  | grep -i $app) != "" ]]
then
  cat $app.yaml | kubectl replace -f -
else
  kubectl create -f $app.yaml
fi
# this is for exposiing the service
#kubectl create -f $app-lb.yaml
