# ms-buddyfinder Puppet

* Install Puppet via console; choose 2016.1 template
* ssh into newly create puppetmaster
* sudo su -
* apt-get update && apt-get -y install git
* git clone https://github.com/chrisvugrinec/ms-buddyfinder.git
* cd ./ms-buddyfinder/01_puppet/
* ./prepAzureCli.sh ( installs everything you need to use the azure api on your linux host)
* ./createAzureLogin.sh ( creates a application SP in AD and a certificate, creates a config file for the puppet master )
  * fill in your APP SP name
  * select your account (if you have more than 1 account)
  * go to your portal AD config (https://ms.portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)
    * select app registrations and select the app you just created with the script
    * go to KEYS and generate a key (please copy this key...as it will never be visible after you saved it)  
    * just to be sure paste your key in notepad (afterwards this wizzard you do not need to keep it anymore)
* ./configPuppet.sh [name of your app]
  * give the name of the APP SP you just created as parameter
  * at the end of the script you need to edit the /etc/puppetlabs/puppet/azure.conf file
  * paste your key as value for the client_secret: key

There you are done !!!
