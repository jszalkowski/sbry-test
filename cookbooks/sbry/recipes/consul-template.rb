group node['sbry']['consul-template']['ct-group'] do
	action :create
	system true
end

user node['sbry']['consul-template']['ct-user'] do
	comment 'consul'
	system true
	shell '/bin/false'
end

directory node['sbry']['consul-template']['root'] do
	owner node['sbry']['consul-template']['ct-user']
	group	node['sbry']['consul-template']['ct-group']
	mode '0755'
	action :create
end

extract_path = "#{node['sbry']['consul-template']['root']}/consul-template"

remote_file "#{Chef::Config[:file_cache_path]}/consul-template.zip" do
	source node['sbry']['consul-template']['url']
	owner node['sbry']['consul-template']['ct-user']
	group	node['sbry']['consul-template']['ct-group']
	mode '0755'
	action :create
end

execute 'unzip-consul-template' do
	command <<-EOH
		unzip #{Chef::Config[:file_cache_path]}/consul-template.zip -d #{node['sbry']['consul-template']['root']} 
		EOH
	not_if{::File.exists?(extract_path)}
end

template node['sbry']['consul-template']['config_file'] do
	source'consul-template.erb'
	owner node['sbry']['consul-template']['ct-user']
	group node['sbry']['consul-template']['ct-group']
	mode'0644'
	variables({
		:listener => node['sbry']['consul-template']['listener'],
		:template_source => node['sbry']['consul-template']['template-source'],
		:template_dest => node['sbry']['consul-template']['template-dest'],
		:template_cmd => node['sbry']['consul-template']['template-cmd'],
		:retry => node['sbry']['consul-template']['retry']})
	notifies :restart, 'service[consul-template]'
end


template '/etc/systemd/system/consul-template.service' do
	source'consul-template.service.erb'
	owner node['sbry']['consul-template']['ct-user']
	group node['sbry']['consul-template']['ct-group']
	mode'0644'
	variables({
		:listener => node['sbry']['consul-template']['listener'],
		:bin => node['sbry']['consul-template']['bin'],
		:config => node['sbry']['consul-template']['config']})
	notifies :restart, 'service[consul-template]'
end

service "consul-template" do
	action [:enable, :start]
end
