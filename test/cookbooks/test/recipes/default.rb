yum_repository 'codeit' do
  baseurl "https://repo.codeit.guru/packages/centos/#{node['platform_version'].to_i}/$basearch"
  gpgkey 'https://repo.codeit.guru/RPM-GPG-KEY-codeit'
end

apt_update 'update'

apache2_install 'default_install'

apache2_site '000-default' do
  action :disable
end

apache2_default_site '' do
  action :enable
end

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end
