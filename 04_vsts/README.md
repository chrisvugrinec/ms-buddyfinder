# ms-buddyfinder

## buildagent

* create a VSTS account (https://www.visualstudio.com/free-developer-offers/), trust me you will love it...
* login to your vsts and create a new project
* go to agent pools (in your settings) and create a new pool
* if you created the buildagent from step 01, you can login to this machine. If not create the machine by following these steps:
  * cd 01_puppet/puppet-templates   
  * generateapp.sh
  * puppet apply NAME_OF_AGENT.pp
* ssh into your buildagent and become the vsts user. sudo su - && su - vsts
* cd ~/bagent
* ./config.sh
  * enter server URL ; this is the url for your VSTS account, for eg. https://dr-doom.visualstudio.com
  * select PAT (personal authentication token)
  * enter your PAT ; you can generate this in vsts, click on your avator and select security (be carefull this token is only visible once)

## Docker Registry connection (private)
* Add new Docker Registry Connection
  * Connection name: just fill in a name
  * Docker Registry: the url of your docker registry (you can find this in your docker registry properties)
  * docker id: the admin username of your docker registry
  * password: your docker pass reg password

## Nginx Config frontend app
* edit ms-buddyfinder/04_vsts/code/ms-buddyfinder-nginx/src/index.js so that the data of your REDIS is used
* now configure your build in vsts for this app
* builds, new definition , select Empty
* select remote repository, connect to https://github.com/chrisvugrinec/ms-buddyfinder.git
* configure build steps
* if docker is not amongst the available solutions, select it from the marketplace
* make your docker config point to: ms-buddyfinder/04_vsts/code/ms-buddyfinder-nginx/Dockerfile and run the build
