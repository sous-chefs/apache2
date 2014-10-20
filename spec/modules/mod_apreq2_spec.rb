require 'spec_helper'

describe 'apache2::mod_apreq2' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("test -f #{property[:apache][:libexec_dir]}/mod_apreq2.so").and_return(true)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        if %w(redhat centos fedora arch).include?(platform)
          it 'installs package libapreq2' do
            expect(chef_run).to install_package('libapreq2')
            expect(chef_run).to_not install_package('not_libapreq2')
          end
          let(:package) { chef_run.package('libapreq2') }
          it 'triggers a notification by libapreq2 package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w(suse).include?(platform)
          it 'installs package apache2-mod_apreq2' do
            expect(chef_run).to install_package('apache2-mod_apreq2')
            expect(chef_run).to_not install_package('not_apache2-mod_apreq2')
          end
          let(:package) { chef_run.package('apache2-mod_apreq2') }
          it 'triggers a notification by apache2-mod_apreq2 package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w(debian ubuntu).include?(platform)
          it 'installs package libapache2-mod-apreq2' do
            expect(chef_run).to install_package('libapache2-mod-apreq2')
            expect(chef_run).to_not install_package('not_libapache2-mod-apreq2')
          end
        end

        it "deletes #{property[:apache][:dir]}/conf.d/apreq.conf" do
          expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/apreq.conf").with(:backup => false)
          expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/apreq.conf").with(:backup => true)
        end
        it_should_behave_like 'an apache2 module', 'apreq', false
      end
    end
  end
end
