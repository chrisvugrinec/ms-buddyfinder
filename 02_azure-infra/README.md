# ms-buddyfinder Puppet

## Setup Azure components needed for demo project

The following (infra)components are needed for this demo:
* private docker registry
* redis cache (scaleable solution from marketplace) used as pub/sub solution
* azure container service, kubernetes cluster

* azure_mplace_dockerregistry
  * cd azure_mplace_dockerregistry
  * puppet module build
  * cd pkg
  * puppel module install cvugrinec-azure_mplace_dockerregistry-0.1.0.tar.gz
  * you can configure the module with the config in /etc/puppetlabs/code/environments/production/hieradata/common.yaml
  * go to your puppet console and add this module to your puppetmaster 
* same goes for azure_mplace_redis and azure_acs_kubernetes
