apache2_install 'default' do
  mpm 'prefork'
end

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end

apache2_mod_wsgi

# Required for hello world on suse
package 'python3-webencodings' if platform_family?('suse')

app_dir = '/var/www/wsgi_site/htdocs'
wsgi_dir = '/var/www/wsgi_site/wsgi-scripts'

directory app_dir do
  recursive true
end

directory wsgi_dir do
  recursive true
end

cookbook_file "#{wsgi_dir}/test.wsgi" do
  notifies :restart, 'service[apache2]'
end

apache2_default_site 'wsgi_site' do
  default_site_name 'wsgi_site'
  template_cookbook 'test'
  template_source 'wsgi_site.conf.erb'
  variables(
    server_name: '127.0.0.1',
    document_root: app_dir,
    wsgi_root: wsgi_dir,
    log_dir: lazy { default_log_dir },
    site_name: 'wsgi_site'
  )
  notifies :restart, 'service[apache2]'
end

apache2_site 'wsgi_site' do
  notifies :restart, 'service[apache2]'
end

apache2_site '000-default' do
  action :disable
end
