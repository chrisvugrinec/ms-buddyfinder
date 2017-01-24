#!/bin/bash
resourcegroup=$1
dregistryname=$2
azure group deployment create $resourcegroup -p "{\"registries_msbfdregistry_name\":{\"value\":\"""$dregistryname""\"}}" --template-file dregistry.json
