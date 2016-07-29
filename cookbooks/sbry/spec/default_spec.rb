require 'chefspec'

describe 'vim::default' do
  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
  end
end
