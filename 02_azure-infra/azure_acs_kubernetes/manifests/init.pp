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
    command     => "config-kubecluster.sh $numberofnodes",
    cwd         => '/opt/puppet/',
    path        => '/root/go/bin/:/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    user        => "root",
    refreshonly => false,
    timeout     => 1800,
  }->
  exec { 'create_acs_kube':
    command     => "create-kubecluster.sh $resourcegroup",
    cwd         => '/opt/puppet/',
    path        => '/root/go/bin/:/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    user        => "root",
    refreshonly => false,
    timeout     => 1800,
  }
}
