require 'spec_helper'
describe 'azure_mplace_dockerregistry' do

  context 'with default values for all parameters' do
    it { should contain_class('azure_mplace_dockerregistry') }
  end
end
