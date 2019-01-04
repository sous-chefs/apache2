apache2_install 'default'

directory '/var/www/basic_web_app' do
  recursive true
end

file '/var/www/index.html' do
  content 'Hello World'
end

web_app 'basic_webapp' do
  cookbook 'apache2'
  server_name 'example.com'
  server_aliases [node['fqdn']]
  docroot '/home/apache2/env'
end
