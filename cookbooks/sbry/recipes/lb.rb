package 'nginx'
template '/opt/consul/default.ctmpl' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'nginx' do
  action [:enable, :start]
end
