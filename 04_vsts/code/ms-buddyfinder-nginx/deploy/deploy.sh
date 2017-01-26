#!/bin/bash

app=$1
dockerimage=$2
buildnr=$3
redisurl=$4
redispassword=$5

cat template.yaml | sed 's/XXX_APP_XXX/'$app'/' >$app.yaml
sed -i 's/XXX_DOCKERIMG_XXX/'$dockerimage'/' $app.yaml
sed -i 's/XXX_BUILDNR_XXX/'$buildnr'/' $app.yaml
sed -i 's/XXX_REDIS_URL_XXX/'$redisurl'/' $app.yaml
sed -i 's/XXX_REDIS_PASSWORD_XXX/'$redispassword'/' $app.yaml

# check if pod exists..if exists do a kubectl rolling-update 
if [[ $(kubectl get pods  | grep -i $app) != "" ]]
then
  cat $app.yaml | kubectl replace -f -
else
  kubectl create -f $app.yaml
fi
# this is for exposiing the service
#kubectl create -f $app-lb.yaml
