class azure_acs_kubernetes {

  $resourcegroup= hiera('azure-acs-kube.resourcegroup')
  $numberofnodes= hiera('azure-acs-kube.numberofnodes')

  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
  package { 'gccgo-go':
    ensure  => installed,
    require => Exec['apt-update'],
  }->
  package { 'uuid':
    ensure  => installed,
  }
  ssh_keygen { 'root':
    type => 'rsa'
  }->
  file { '/opt/puppet/create-kubecluster.sh':
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/azure_acs_kubernetes/create-kubecluster.sh',
  }->
  exec { 'install_acs_kube':
    command     => 'install_dregistry.sh $resourcegroup $numberofnodes',
    cwd         => '/opt/puppet/',
    path        => '/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    refreshonly => true,
    timeout     => 18000,
  }

}
