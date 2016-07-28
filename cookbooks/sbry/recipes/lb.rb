node['sbry']['lb']['packages'].each do |pkg|
        package pkg
end

template '/opt/consul/default.ctmpl' do
  source  'nginx.conf.erb'
  owner   'root'
  group   'root'
  mode    '0644'
end
