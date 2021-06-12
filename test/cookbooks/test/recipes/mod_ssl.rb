ssl_cert_file     = "#{apache_dir}/ssl/server.crt"
ssl_cert_key_file = "#{apache_dir}/ssl/server.key"
app_dir           = '/var/www/basic_site'

apache2_install 'default'

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end

apache2_module 'deflate'
apache2_module 'headers'
apache2_module 'ssl'

apache2_mod_ssl ''

directory app_dir do
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

file "#{app_dir}/index.html" do
  content 'Hello World'
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
end

# Create Certificates
openssl_x509_certificate 'create-certificate' do
  path ssl_cert_file
  key_file ssl_cert_key_file
  expire 2
  renew_before_expiry 1
  common_name '127.0.0.1'
  owner 'root'
  group 'root'
  email 'help@sous-chefs.org'
  org_unit 'Sous Chefs'
  org 'Chef Software, Inc'
  city 'Seattle'
  state 'Washington'
  country 'US'
  mode '0640'
end

# Create site template with our custom config
site_name = 'ssl_site'

apache2_default_site site_name do
  default_site_name site_name
  template_cookbook 'test'
  template_source 'ssl.conf.erb'
  variables(
    server_name: '127.0.0.1',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    ssl_cert_file: ssl_cert_file,
    ssl_cert_key_file: ssl_cert_key_file,
  )
end

apache2_site site_name
