require 'spec_helper'
describe 'azure_acs_kubernetes' do

  context 'with default values for all parameters' do
    it { should contain_class('azure_acs_kubernetes') }
  end
end
