require 'spec_helper'

describe 'sbry::lb' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'template for nginx backends' do
    expect(chef_run).to create_template('/opt/consul/default.ctmpl')
  end

  it 'enables service' do
    expect(chef_run).to enable_service('nginx')
  end

  it 'starts service' do
    expect(chef_run).to start_service('nginx')
  end
end
