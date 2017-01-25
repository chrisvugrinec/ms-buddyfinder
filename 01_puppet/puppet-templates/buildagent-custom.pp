azure_vm { 'buildagent1':
  location                      => 'westeurope',
  image                         => 'canonical:UbuntuServer:16.10:16.10.201701030',
  user                          => 'chris',
  password                      => 'HelloWorld123!',
  size                          => 'Standard_D2_V2',
  resource_group                => 'msbf-demo',
  storage_account               => 'cvugrinecdemo',
  storage_account_type          => 'Standard_GRS',
  os_disk_name                  => 'osdisk01',
  os_disk_caching               => 'ReadWrite',
  os_disk_create_option         => 'fromImage',
  os_disk_vhd_container_name    => 'buildagent1',
  os_disk_vhd_name              => 'buildagent1',
  dns_servers                   => '8.8.8.8 10.1.1.1',
  public_ip_allocation_method   => 'Dynamic',
  public_ip_address_name        => 'buildagent1',
  virtual_network_name          => 'vnet01',
  virtual_network_address_space => '10.0.0.0/16',
  subnet_name                   => 'subnet01',
  subnet_address_prefix         => '10.0.0.0/24',
  ip_configuration_name         => 'ip_config_buildagent1',
  private_ip_allocation_method  => 'Dynamic',
  network_interface_name        => 'nicbuildagent1',
  extensions                    => {
    'CustomScriptForLinux' => {
       'auto_upgrade_minor_version' => false,
       'publisher'                  => 'Microsoft.Azure.Extensions',
       'type'                       => 'CustomScript',
       'type_handler_version'       => '2.0',
       'settings'                   => {
         'commandToExecute' => 'curl -k https://raw.githubusercontent.com/chrisvugrinec/ms-buddyfinder/master/01_puppet/provisionscripts/provision.sh | sudo bash'
       },
     },
  },
}
