class azure_acs_kubernetes {

  $resourcegroup= hiera('azure-acs-kube.resourcegroup')
  $numberofnodes= hiera('azure-acs-kube.numberofnodes')

  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
  file { '/root/go':
    ensure => 'directory',
  }
  file { '/root/kube':
    ensure => 'directory',
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
  file { '/opt/puppet/config-kubecluster.sh':
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/azure_acs_kubernetes/config-kubecluster.sh',
  }->
  file { '/opt/puppet/create-kubecluster.sh':
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/azure_acs_kubernetes/create-kubecluster.sh',
  }->
  exec { 'config_acs_kube':
    environment => ["GOPATH=/root/go"],
    command     => "config-kubecluster.sh $numberofnodes",
    cwd         => '/opt/puppet/',
    path        => '/root/go/bin/:/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    user        => "root",
    timeout     => 1800,
  }->
    azure_resource_group { "$resourcegroup":
    ensure         => present,
    location       => 'westeurope',
  }->
  exec { 'create_acs_kube':
    command     => "create-kubecluster.sh $resourcegroup",
    cwd         => '/opt/puppet/',
    path        => '/root/go/bin/:/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    user        => "root",
    logoutput   => true,
    provider    => shell,
    timeout     => 1800,
  }
}
