#!/bin/bash
#
# small helper app to guide your through configuring your template
#
echo "new name of file"
read nfile
cp buildagent-custom-template.pp $nfile 
echo "what is the name of the resourcegroup of your puppetmaster"
read rg
sed  -i 's/msbf-demo/'$rg'/g' $nfile
echo "what is the name of your buildagent, ps think of a unique name (DNS)"
read name
sed  -i 's/buildagent1/'$name'/g' $nfile
echo "unique name of your storageaccount (only alfanumeric signs)"
read sa
sed  -i 's/cvugrinecdemo/'$sa'/g' $nfile

