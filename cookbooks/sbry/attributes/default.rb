case node['platform_family']
when 'debian'
  default['sbry']['goapp']['packages'] = %w(gccgo golang ntp zip git)
  default['sbry']['goapp']['group'] = 'nogroup'
when 'rhel'
  default['sbry']['goapp']['packages'] = ['gcc-go', 'golang', 'ntp', 'zip', 'unzip', 'git']
  default['sbry']['goapp']['group'] = 'nobody'
end
default['sbry']['goapp']['goapp_root'] = '/opt/goapp'
default['sbry']['goapp']['user'] = 'nobody'
default['sbry']['goapp']['gitrepo'] = 'https://github.com/jszalkowski/sbry-test.git'
default['sbry']['goapp']['gitbranch'] = 'master'
default['sbry']['goapp']['name'] = 'go'
default['sbry']['goapp']['port'] = '8484'
default['sbry']['goapp']['tag'] = 'go'
default['sbry']['goapp']['script'] = 'curl localhost:8484 >/dev/null 2>&1'
default['sbry']['goapp']['interval'] = '10s'
default['sbry']['consul']['goconfig'] = 'web.json'
default['sbry']['consul']['user'] = 'daemon'
default['sbry']['consul']['group'] = 'daemon'
default['sbry']['consul']['root'] = '/opt/consul'
default['sbry']['consul']['consul_url'] = 'https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip'
default['sbry']['consul_template']['listener'] = 'localhost:8500'
default['sbry']['consul_template']['template-source'] = '/opt/consul/default.ctmpl'
default['sbry']['consul_template']['template-dest'] = '/etc/nginx/sites-available/default'
default['sbry']['consul_template']['template-cmd'] = 'systemctl restart nginx'
default['sbry']['consul_template']['retry'] = '10s'
default['sbry']['consul_template']['bin'] = '/opt/consul/consul_template'
default['sbry']['consul_template']['config'] = '/opt/consul/consul_template.json'
default['sbry']['consul_template']['ct-user'] = 'daemon'
default['sbry']['consul_template']['ct-group'] = 'daemon'
default['sbry']['consul_template']['root'] = '/opt/consul'
default['sbry']['consul_template']['url'] = 'https://releases.hashicorp.com/consul_template/0.15.0/consul_template_0.15.0_linux_amd64.zip'
default['sbry']['consul_template']['config_file'] = '/opt/consul/consul_template.json'
