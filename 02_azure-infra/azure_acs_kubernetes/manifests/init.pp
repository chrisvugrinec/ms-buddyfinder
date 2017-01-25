class azure_acs_kubernetes {

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
  }
}
