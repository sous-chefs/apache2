require 'spec_helper'

describe 'apache2::mod_auth_openid' do
  before do
    stub_command('test -f /var/chef/cache/mod_auth_openid-95043901eab868400937642d9bc55d17e9dd069f/src/.libs/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/lib64/httpd/modules/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/local/libexec/apache22/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/lib/httpd/modules/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/lib/apache2/modules/mod_auth_openid.so').and_return(true)

  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        if %w(debian ubuntu).include?(platform)
          %w(automake make g++ apache2-prefork-dev libopkele-dev libopkele3 libtool).each do |package|
            it "installs package #{package}" do
              expect(chef_run).to install_package(package)
            end
          end
        elsif %w(redhat centos fedora).include?(platform)
          %w(gcc-c++ httpd-devel curl-devel libtidy libtidy-devel sqlite-devel pcre-devel openssl-devel make libtool).each do |package|
            it "installs package #{package}" do
              expect(chef_run).to install_package(package)
            end
          end
        elsif %w(arch).include?(platform)
          it 'includes the `pacman::default` recipe' do
            expect(chef_run).to include_recipe('pacman::default')
          end
          %w(tidyhtml).each do |package|
            it "installs package #{package}" do
              expect(chef_run).to install_package(package)
            end
          end
        elsif %w(freebsd).include?(platform)
          %w(libopkele pcre sqlite3).each do |package|
            it "installs package #{package}" do
              expect(chef_run).to install_package(package)
            end
          end
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'authopenid', false, supported_platforms, 'mod_auth_openid.so'
end
