#!/bin/bash
#
# small helper app to guide your through configuring your template
#
echo "what is the name of the resourcegroup of your puppetmaster"
read rg
sed  -i 's/msbf-demo/'$rg'/g' buildagent-custom.pp
echo "what is the name of your buildagent, ps think of a unique name (DNS)"
read name
sed  -i 's/buildagent1/'$name'/g' buildagent-custom.pp
echo "unique name of your storageaccount (only alfanumeric signs)"
read sa
sed  -i 's/cvugrinecdemo/'$sa'/g' buildagent-custom.pp

