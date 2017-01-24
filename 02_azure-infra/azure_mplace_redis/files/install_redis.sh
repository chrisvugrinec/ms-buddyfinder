#!/bin/bash
resourcegroup=$1
rcachename=$2
sname=$3
azure group deployment create $resourcegroup -p "{\"redisCacheName\":{\"value\":\""$rcachename""\"},\"existingDiagnosticsStorageAccountName\":{\"value\":\""$sname""\"}}" --template-file redis.json 
