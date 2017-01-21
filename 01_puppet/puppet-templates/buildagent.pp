azure_vm { 'buildagent-no2':
  ensure         => present,
  location       => 'westeurope',
  image          => 'canonical:ubuntuserver:14.04.2-LTS:latest',
  user           => 'chris',
  password       => 'HelloWorld123!',
  size           => 'Standard_A0',
  resource_group => 'demo-infra',
}
