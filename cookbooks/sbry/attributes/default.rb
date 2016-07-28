default['sbry']['lb']['packages'] = [ 'nginx', 'ntp', 'zip']
default['sbry']['goapp']['packages'] = ['gccgo', 'golang', 'ntp', 'zip']
default['sbry']['consul_url'] = 'https://releases.hashicorp.com/terraform/0.6.16/terraform_0.6.16_linux_amd64.zip'
default['sbry']['goapp']['goapp_root'] = '/opt/goapp'
default['sbry']['goapp']['user'] = 'nobody'
default['sbry']['goapp']['group'] = 'nogroup' 
default['sbry']['goapp']['gitrepo'] = 'https://github.com/jszalkowski/sbry-test.git'
default['sbry']['goapp']['gitbranch'] = 'goapp'
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
default['sbry']['consul-template']['listener'] = 'localhost:8500'
default['sbry']['consul-template']['template-source'] = '/opt/consul/default.ctmpl'
default['sbry']['consul-template']['template-dest'] =  '/etc/nginx/sites-available/default'
default['sbry']['consul-template']['template-cmd'] = 'systemctl restart nginx'
default['sbry']['consul-template']['retry'] = '10s'
default['sbry']['consul-template']['bin'] = '/opt/consul/consul-template'
default['sbry']['consul-template']['config'] = '/opt/consul/consul-template.json'
default['sbry']['consul-template']['ct-user'] = 'daemon'
default['sbry']['consul-template']['ct-group'] = 'daemon'
default['sbry']['consul-template']['root'] = '/opt/consul'
default['sbry']['consul-template']['url'] = 'https://releases.hashicorp.com/consul-template/0.15.0/consul-template_0.15.0_linux_amd64.zip'
default['sbry']['consul-template']['config_file'] = '/opt/consul/consul-template.json'