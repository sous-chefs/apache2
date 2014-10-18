require 'spec_helper'

describe 'apache2::mod_fastcgi' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("test -f #{property[:apache][:dir]}/mods-available/fastcgi.conf").and_return(true)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        if %w(debian ubuntu).include?(platform)
          it 'installs package libapache2-mod-fastcgi' do
            expect(chef_run).to install_package('libapache2-mod-fastcgi')
          end
        elsif %w(redhat centos).include?(platform)
          %w(gcc make libtool httpd-devel apr-devel apr).each do |package|
            it "installs package #{package}" do
              expect(chef_run).to upgrade_yum_package(package)
            end
          end
        end
        it_should_behave_like 'an apache2 module', 'fastcgi', true
      end
    end
  end
end
