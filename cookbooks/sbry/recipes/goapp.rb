include_recipe 'yum-epel' if platform_family?('rhel')
node['sbry']['goapp']['packages'].each do |pkg|
  package pkg
end

directory node['sbry']['goapp']['goapp_root'] do
  owner node['sbry']['goapp']['user']
  group node['sbry']['goapp']['group']
  mode'755'
end

git node['sbry']['goapp']['goapp_root'] do
  repository node['sbry']['goapp']['gitrepo']
  user node['sbry']['goapp']['user']
  group node['sbry']['goapp']['group']
  action :checkout
  notifies :run, 'execute[build-app]', :immediately
end

execute 'build-app' do
  command 'gccgo goapp.go -o goapp'
  cwd node['sbry']['goapp']['goapp_root']
  user node['sbry']['goapp']['user']
  notifies :restart, 'service[goapp]'
end

template '/etc/systemd/system/goapp.service' do
  source'goapp.service.erb'
  owner node['sbry']['goapp']['user']
  group node['sbry']['goapp']['group']
  mode'0644'
  notifies :restart, 'service[goapp]'
end

service 'goapp' do
  action [:enable, :start]
end
