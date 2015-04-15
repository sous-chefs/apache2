service 'apache2' do
  service_name node['apache']['service_name']
  case node['platform_family']
  when 'rhel'
    reload_command '/sbin/service httpd graceful'
  when 'debian'
    provider Chef::Provider::Service::Debian
  when 'arch'
    service_name 'httpd'
  end
  supports [:start, :restart, :reload, :status]
  action [:enable, :start]
  only_if "#{node['apache']['binary']} -t", :environment => { 'APACHE_LOG_DIR' => node['apache']['log_dir'] }, :timeout => 10
end