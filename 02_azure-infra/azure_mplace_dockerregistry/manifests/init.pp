class azure_mplace_dockerregistry {

  $resourcegroup= hiera("azure-dockerregistry.resourcegroup")
  $dockerregistryname= hiera("azure-dockerregistry.name")

  file { '/opt/puppet':
    ensure => 'directory',
  }

  file { "/opt/puppet/install_dregistry.sh":
     mode => '0750',
     owner => 'root',
     group => 'root',
     source => "puppet:///modules/azure_mplace_dockerregistry/install_dregistry.sh",
  }

  file { "/opt/puppet/dregistry.json":
     mode => '0750',
     owner => 'root',
     group => 'root',
     source => "puppet:///modules/azure_mplace_dockerregistry/dregistry.json",
  }

  file { "/opt/puppet/certificate.pem":
     mode => '0750',
     owner => 'root',
     group => 'root',
     source => "/root/ms-buddyfinder/01_puppet/certificate.pem",
  }

  exec { "install_dockerregistry":
    command => "install_dregistry.sh" $resourcegroup $dockerregistryname",
    cwd => "/opt/puppet/",
    path => '/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    refreshonly => true,
    timeout     => 18000,
  }

}
