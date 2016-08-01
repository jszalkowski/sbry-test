require 'spec_helper'

describe 'sbry::consul_template' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'create consul_template directory' do
    expect(chef_run).to create_directory('/opt/consul')
  end

  it 'creates an user' do
    expect(chef_run).to create_user('daemon')
  end

  it 'creates an group' do
    expect(chef_run).to create_group('daemon')
  end

  it 'unzips the zip' do
    expect(chef_run).to run_execute('unzip-consul_template')
  end
  it 'creates template for consul_template start' do
    expect(chef_run).to create_template('/opt/consul/consul_template.json')
  end

  it 'creates systemd config file for consul_template' do
    expect(chef_run).to create_template('/etc/systemd/system/consul_template.service')
  end

  it 'enables service' do
    expect(chef_run).to enable_service('consul_template')
  end

  it 'starts service' do
    expect(chef_run).to start_service('consul_template')
  end
end
