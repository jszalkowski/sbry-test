group node['sbry']['consul_template']['ct-group'] do
  action :create
  system true
end

user node['sbry']['consul_template']['ct-user'] do
  comment 'consul'
  system true
  shell '/bin/false'
end

directory node['sbry']['consul_template']['root'] do
  owner node['sbry']['consul_template']['ct-user']
  group	node['sbry']['consul_template']['ct-group']
  mode '0755'
  action :create
end

extract_path = "#{node['sbry']['consul_template']['root']}/consul_template"

remote_file "#{Chef::Config[:file_cache_path]}/consul_template.zip" do
  source node['sbry']['consul_template']['url']
  owner node['sbry']['consul_template']['ct-user']
  group	node['sbry']['consul_template']['ct-group']
  mode '0755'
  action :create
end

execute 'unzip-consul_template' do
  command <<-EOH
		unzip #{Chef::Config[:file_cache_path]}/consul_template.zip -d #{node['sbry']['consul_template']['root']}
		EOH
  not_if { ::File.exist?(extract_path) }
end

template node['sbry']['consul_template']['config_file'] do
  source'consul_template.erb'
  owner node['sbry']['consul_template']['ct-user']
  group node['sbry']['consul_template']['ct-group']
  mode'0644'
  variables(
    'listener' => node['sbry']['consul_template']['listener'],
    'template_source' => node['sbry']['consul_template']['template-source'],
    'template_dest' => node['sbry']['consul_template']['template-dest'],
    'template_cmd' => node['sbry']['consul_template']['template-cmd'],
    'retry' => node['sbry']['consul_template']['retry']
  )
  notifies :restart, 'service[consul_template]'
end

template '/etc/systemd/system/consul_template.service' do
  source'consul_template.service.erb'
  owner node['sbry']['consul_template']['ct-user']
  group node['sbry']['consul_template']['ct-group']
  mode'0644'
  variables('listener' => node['sbry']['consul_template']['listener'],
            'bin' => node['sbry']['consul_template']['bin'],
            'config' => node['sbry']['consul_template']['config'])
  notifies :restart, 'service[consul_template]'
end

service 'consul_template' do
  action [:enable, :start]
end
