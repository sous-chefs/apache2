require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2'],
  'suse' => ['11.3']
}
#  'arch' =>

# not supported modules: authn_alias authn_anon authn_dbd authn_dbm authn_default authz_dbm authz_ldap authz_owner
aaa_modules_without_config = %w(auth_basic auth_digest authz_default authz_groupfile authz_host authz_user authn_file)
aaa_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# @todo add support for windows
# arch_win32_modules_without_config = %w(isapi win32)
#
# arch_win32_modules_without_config.each do |mod|
#  describe "apache2::mod_#{mod}" do
#    it_should_behave_like 'an apache2 module', mod, false, platforms
#  end
# end

# not supported modules: cache disk_cache file_cache mem_cache
cache_modules_without_config = %w()
cache_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# not supported modules: dbd
database_modules_without_config = %w()
database_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# not supported modules: dav_lock
dav_modules_without_config = %w(dav dav_fs)
dav_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# not supported modules: charset_lite ext_filter reqtimeout substitute
filters_modules_without_config = %w(filter)
filters_modules_with_config = %w(include deflate)
filters_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
filters_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: asis cgid suexec
generators_modules_without_config = %w(cgi)
generators_modules_with_config = %w(autoindex status info)
generators_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
generators_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

http_modules_with_config = %w(mime)
http_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: log_forensic
loggers_modules_without_config = %w(log_config logio)
loggers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms.select { |key, value| %w(redhat fedora suse freebsd).include?(key) }
  end
end

# not supported modules: imagemap speling vhost_alias
mappers_modules_without_config = %w(actions rewrite userdir)
mappers_modules_with_config = %w(alias dir negotiation)
mappers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
mappers_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: cern_meta ident mime_magic unique_id usertrack version
metadata_modules_without_config = %w(env expires headers)
metadata_modules_with_config = %w(setenvif)
metadata_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
metadata_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: proxy_ftp proxy_scgi
proxy_modules_without_config = %w(proxy_ajp proxy_balancer proxy_connect proxy_http)
proxy_modules_with_config = %w(proxy)
proxy_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
proxy_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

describe 'apache2::mod_ssl' do
# if platform_family?('rhel', 'fedora', 'suse')
#   package 'mod_ssl' do
#     notifies :run, 'execute[generate-module-list]', :immediately
#   end

#   file "#{node['apache']['dir']}/conf.d/ssl.conf" do
#     action :delete
#     backup false
#   end
# end

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        it 'creates /etc/apache2/ports.conf' do
          expect(chef_run).to create_template('ssl_ports.conf').with(
            :path => '/etc/apache2/ports.conf',
            :source => 'ports.conf.erb',
            :mode => '0644'
         )
        end

        let(:template) { chef_run.template('ssl_ports.conf') }
        it 'triggers a notification by ssl_ports.conf template to restart service[apache2]' do
          expect(template).to notify('service[apache2]').to(:restart)
          expect(template).to_not notify('service[apache2]').to(:stop)
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'ssl', true, platforms
end
