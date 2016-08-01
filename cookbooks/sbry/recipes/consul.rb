group node['sbry']['consul']['group'] do
  action :create
  system true
end

user node['sbry']['consul']['user'] do
  comment 'consul'
  system true
  shell '/bin/false'
end

directory node['sbry']['consul']['root'] do
  owner node['sbry']['consul']['ct-user']
  group node['sbry']['consul']['ct-group']
  mode '0755'
  action :create
end

extract_path = "#{node['sbry']['consul']['root']}/consul"
remote_file "#{Chef::Config[:file_cache_path]}/consul.zip" do
  source node['sbry']['consul']['consul_url']
  owner node['sbry']['consul']['user']
  group node['sbry']['consul']['group']
  mode '0755'
  action :create
end

execute 'unzip-consul' do
  command <<-EOH
		unzip #{Chef::Config[:file_cache_path]}/consul.zip -d #{node['sbry']['consul']['root']}
		EOH
  not_if { ::File.exist?(extract_path) }
end

template "#{node['sbry']['consul']['root']}/start-consul.sh" do
  source 'start-consul.sh.erb'
  owner node['sbry']['consul']['user']
  group node['sbry']['consul']['group']
  mode'0755'
  variables(root: node['sbry']['consul']['root'],
            goconfig: node['sbry']['consul']['goconfig'])
end

template "#{node['sbry']['consul']['root']}/web.json" do
  source'web.json.erb'
  owner node['sbry']['consul']['user']
  group node['sbry']['consul']['group']
  mode'0755'
  variables(name: node['sbry']['goapp']['name'],
            port: node['sbry']['goapp']['port'],
            tag: node['sbry']['goapp']['tag'],
            script: node['sbry']['goapp']['script'],
            interval: node['sbry']['goapp']['interval'])
end

template '/etc/systemd/system/consul.service' do
  source'consul.service.erb'
  owner 'root'
  group 'root'
  mode'0644'
  notifies :restart, 'service[consul]'
end

service 'consul' do
  action [:enable, :start]
end
