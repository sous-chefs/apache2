require 'spec_helper'

describe 'apache2::mod_perl' do
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

        if %w(redhat centos fedora arch).include?(platform)
          it 'installs package mod_perl' do
            expect(chef_run).to install_package('mod_perl')
            expect(chef_run).to_not install_package('not_mod_perl')
          end
          let(:package) { chef_run.package('mod_perl') }
          it 'triggers a notification by mod_perl package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
          it 'installs package perl-libapreq2' do
            expect(chef_run).to install_package('perl-libapreq2')
            expect(chef_run).to_not install_package('not_perl-libapreq2')
          end
        end
        if %w(suse).include?(platform)
          it 'installs package apache2-mod_perl' do
            expect(chef_run).to install_package('apache2-mod_perl')
            expect(chef_run).to_not install_package('not_apache2-mod_perl')
          end
          let(:package) { chef_run.package('apache2-mod_perl') }
          it 'triggers a notification by apache2-mod_perl package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
          it 'installs package perl-Apache2-Request' do
            expect(chef_run).to install_package('perl-Apache2-Request')
            expect(chef_run).to_not install_package('not_Apache2-Request')
          end
        end
        if %w(debian ubuntu).include?(platform)
          %w(libapache2-mod-perl2 libapache2-request-perl apache2-mpm-prefork).each do |pkg|
            it "installs package #{pkg}" do
              expect(chef_run).to install_package(pkg)
              expect(chef_run).to_not install_package("not_#{pkg}")
            end
          end
        end

        it "deletes #{property[:apache][:dir]}/conf.d/perl.conf" do
          expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/perl.conf").with(:backup => false)
          expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/perl.conf").with(:backup => true)
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'perl', false, supported_platforms
end
