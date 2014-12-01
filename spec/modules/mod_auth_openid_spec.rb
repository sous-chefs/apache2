require 'spec_helper'

describe 'apache2::mod_auth_openid' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("test -f #{Chef::Config[:file_cache_path]}/mod_auth_openid-#{property[:apache][:mod_auth_openid][:version]}/src/.libs/mod_auth_openid.so").and_return(true)
          stub_command("test -f #{property[:apache][:libexec_dir]}/mod_auth_openid.so").and_return(true)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        if %w(debian ubuntu suse opensuse).include?(platform)
          %w(automake make g++ apache2-prefork-dev libopkele-dev libopkele3 libtool).each do |package|
            it "installs package #{package}" do
              expect(chef_run).to install_package(package)
            end
          end
        elsif %w(amazon redhat centos fedora).include?(platform)
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

        it_should_behave_like 'an apache2 module', 'authopenid', false, 'mod_auth_openid.so'
      end
    end
  end
end
