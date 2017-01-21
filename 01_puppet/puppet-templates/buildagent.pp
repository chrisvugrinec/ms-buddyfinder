azure_vm_classic { 'virtual-machine-name':
  ensure           => present,
  image            => 'b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04_2-LTS-amd64-server-20150706-en-us-30GB',
  location         => 'West Europe',
  user             => 'chris',
  size             => 'Medium',
  private_key_file => '~/.ssh/id_rsa.pub',
}
