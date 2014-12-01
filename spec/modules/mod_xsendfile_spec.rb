require 'spec_helper'

describe 'apache2::mod_xsendfile' do
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
          @chef_run.converge(described_recipe)
        end

        if %w(amazon redhat centos fedora arch).include?(platform)
          it 'installs package mod_xsendfile' do
            expect(chef_run).to install_package('mod_xsendfile')
            expect(chef_run).to_not install_package('not_mod_xsendfile')
          end
          let(:package) { chef_run.package('mod_xsendfile') }
          it 'triggers a notification by mod_xsendfile package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w(suse).include?(platform)
          it 'installs package apache2-mod_xsendfile' do
            expect(chef_run).to install_package('apache2-mod_xsendfile')
            expect(chef_run).to_not install_package('not_apache2-mod_xsendfile')
          end
          let(:package) { chef_run.package('apache2-mod_xsendfile') }
          it 'triggers a notification by mod_xsendfile package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w(debian ubuntu).include?(platform)
          it 'installs package libapache2-mod-xsendfile' do
            expect(chef_run).to install_package('libapache2-mod-xsendfile')
            expect(chef_run).to_not install_package('not_libapache2-mod-xsendfile')
          end
        end

        it "deletes #{property[:apache][:dir]}/conf.d/xsendfile.conf" do
          expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/xsendfile.conf").with(:backup => false)
          expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/xsendfile.conf").with(:backup => true)
        end
        it_should_behave_like 'an apache2 module', 'xsendfile', false
      end
    end
  end
end
