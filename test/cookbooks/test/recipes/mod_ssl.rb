ssl_dir           = '/home/apache2'
ssl_cert_file     = "#{ssl_dir}/server.crt"
ssl_cert_key_file = "#{ssl_dir}/server.key"
app_dir           = '/var/www/basic_site'

apache2_install 'default'

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'deflate'
apache2_module 'headers'
apache2_module 'ssl'

apache2_mod_ssl ''

# Create Certificates
directory '/home/apache2' do
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

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

execute 'create-private-key' do
  command "openssl genrsa > #{ssl_cert_key_file}"
  not_if { ::File.exist?(ssl_cert_key_file) }
end

execute 'create-certficate' do
  command %(openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout #{ssl_cert_key_file} -out #{ssl_cert_file} <<EOF
US
Washington
Seattle
Chef Software, Inc

127.0.0.1
webmaster@example.com
EOF)
  not_if { ::File.exist?(ssl_cert_file) }
end

# Create site template with our custom config
site_name = 'ssl_site'

template site_name do
  source 'ssl.conf.erb'
  path "#{apache_dir}/sites-available/#{site_name}.conf"
  variables(
    server_name: '127.0.0.1',
    # server_name: 'example.com',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: site_name,
    ssl_cert_file: ssl_cert_file,
    ssl_cert_key_file: ssl_cert_key_file
  )
end

apache2_site site_name
