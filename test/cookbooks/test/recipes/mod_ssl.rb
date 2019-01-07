ssl_dir           = '/home/apache2'
ssl_cert_file     = "#{ssl_dir}/server.crt"
ssl_cert_key_file = "#{ssl_dir}/server.key"
app_dir           = '/var/www/basic_site'

apache2_install 'default'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'deflate'
apache2_module 'headers'
apache2_module 'ssl'

apache2_mod_ssl 'foo'

# # Create Certificates
directory '/home/apache2' do
  extend    Apache2::Cookbook::Helpers
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

execute 'create-private-key' do
  command "openssl genrsa > #{ssl_cert_key_file}"
  not_if { File.exist?(ssl_cert_key_file) }
end

execute 'create-certficate' do
  command %(openssl req -new -x509 -key #{ssl_cert_key_file} -out #{ssl_cert_file} -days 1 <<EOF
US
Washington
Seattle
Chef Software, Inc

example.com
webmaster@example.com
EOF)
  not_if { File.exist?(ssl_cert_file) }
end

# # Create site template with our custom config
site_name = 'ssl_site'

template site_name do
  extend Apache2::Cookbook::Helpers
  source 'ssl.conf.erb'
  path "#{apache_dir}/sites-available/ssl.conf.conf"
  variables(
    # server_name: '127.0.0.1',
    server_name: 'example.com',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: site_name,
    ssl_cert_file: ssl_cert_file,
    ssl_cert_key_file: ssl_cert_key_file
  )
end

apache2_site site_name
