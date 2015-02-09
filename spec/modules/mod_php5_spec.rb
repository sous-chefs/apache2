require 'spec_helper'

describe 'apache2::mod_php5' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          stub_command('which php').and_return(false)
          @chef_run.converge(described_recipe)
        end

        if %w(amazon redhat centos fedora arch).include?(platform)
          pkg = 'php'
          pkg = 'php53' if version.to_f < 6.0
          it "installs package #{pkg}" do
            expect(chef_run).to install_yum_package(pkg)
            expect(chef_run).to_not install_yum_package("not_#{pkg}")
          end
          let(:package) { chef_run.yum_package(pkg) }
          it "triggers a notification by #{pkg} package install to execute[generate-module-list]" do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w(suse).include?(platform)
          it 'installs package php' do
            expect(chef_run).to install_package('php')
            expect(chef_run).to_not install_package('not_php')
          end
          let(:package) { chef_run.package('php') }
          it 'triggers a notification by php package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w(debian ubuntu).include?(platform)
          it 'installs package libapache2-mod-php5' do
            expect(chef_run).to install_package('libapache2-mod-php5')
            expect(chef_run).to_not install_package('not_libapache2-mod-php5')
          end
        end
        if %w(freebsd).include?(platform)
          %w(php5 mod_php5 libxml2).each do |apkg|
            it "installs package #{apkg}" do
              expect(chef_run).to install_package(apkg)
            end
          end
        end

        it "deletes #{property[:apache][:dir]}/conf.d/php.conf" do
          expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/php.conf").with(:backup => false)
          expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/php.conf").with(:backup => true)
        end
        it_should_behave_like 'an apache2 module', 'php5', true, 'libphp5.so'
      end
    end
  end
end
