class azure_mplace_redis {

  $resourcegroup= hiera("azure-redis.resourcegroup")
  $rediscachename= hiera("azure-redis.rediscachename")
  $storageaccount= hiera("azure-redis.storageaccount")

  file { '/opt/puppet':
    ensure => 'directory',
  }

  file { "/opt/puppet/install_redis.sh":
     mode => '0750',
     owner => 'root',
     group => 'root',
     source => "puppet:///modules/azure_mplace_redis/install_redis.sh",
  }

  file { "/opt/puppet/redis.json":
     mode => '0750',
     owner => 'root',
     group => 'root',
     source => "puppet:///modules/azure_mplace_redis/redis.json",
  }

  file { "/opt/puppet/certificate.pem":
     mode => '0750',
     owner => 'root',
     group => 'root',
     source => "/root/ms-buddyfinder/01_puppet/certificate.pem",
  }

  exec { "install_redis":
    command => "install_redis.sh $resourcegroup $rediscachename $storageaccount",
    cwd => "/opt/puppet/",
    path => '/opt/puppet/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    refreshonly => true,
    timeout     => 18000,
  }



}
