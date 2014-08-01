require 'spec_helper'

# not supported modules: authn_alias authn_anon authn_dbd authn_dbm authn_default authz_dbm authz_ldap authz_owner
aaa_modules_without_config = %w(auth_basic auth_digest authz_core authz_groupfile authz_host authz_user authn_file)
aaa_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end

# @todo add support for windows
# arch_win32_modules_without_config = %w(isapi win32)
#
# arch_win32_modules_without_config.each do |mod|
#  describe "apache2::mod_#{mod}" do
#    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
#  end
# end

# not supported modules: cache disk_cache file_cache mem_cache
cache_modules_without_config = %w()
cache_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end

# not supported modules: dbd
database_modules_without_config = %w()
database_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end

# not supported modules: dav_lock
dav_modules_without_config = %w(dav)
dav_modules_with_config = %w(dav_fs)
dav_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
dav_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

# not supported modules: charset_lite ext_filter reqtimeout substitute
filters_modules_without_config = %w(filter)
filters_modules_with_config = %w(include deflate)
filters_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
filters_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

# not supported modules: asis cgid suexec
generators_modules_without_config = %w(cgi)
generators_modules_with_config = %w(autoindex status info)
generators_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
generators_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

http_modules_with_config = %w(mime)
http_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

# not supported modules: log_forensic
loggers_modules_without_config = %w(log_config logio)
loggers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms.select { |key, _| %w(redhat fedora suse freebsd).include?(key) }
  end
end

# not supported modules: imagemap speling vhost_alias
mappers_modules_without_config = %w(rewrite)
mappers_modules_with_config = %w(actions alias dir userdir negotiation)
mappers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
mappers_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

# not supported modules: cern_meta ident mime_magic unique_id usertrack version
metadata_modules_without_config = %w(env expires headers)
metadata_modules_with_config = %w(setenvif)
metadata_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
metadata_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

# not supported modules: proxy_ftp proxy_scgi
proxy_modules_without_config = %w(proxy_ajp proxy_connect proxy_http)
proxy_modules_with_config = %w(proxy proxy_balancer)
proxy_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
proxy_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end

describe 'apache2::mod_ssl' do

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before do
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
        end

        if %w(redhat centos fedora arch suse).include?(platform)
          it 'installs package mod_ssl' do
            expect(chef_run).to install_package('mod_ssl')
            expect(chef_run).to_not install_package('not_mod_ssl')
          end
          let(:package) { chef_run.package('mod_ssl') }
          it 'triggers a notification by mod_ssl package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
          it "deletes #{property[:apache][:dir]}/conf.d/ssl.conf" do
            expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/ssl.conf").with(:backup => false)
            expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/ssl.conf").with(:backup => true)
          end
        end

        it 'creates /etc/apache2/ports.conf' do
          expect(chef_run).to create_template('ssl_ports.conf').with(
            :path => "#{property[:apache][:dir]}/ports.conf",
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

  it_should_behave_like 'an apache2 module', 'ssl', true, supported_platforms
end
