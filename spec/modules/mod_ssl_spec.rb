require 'spec_helper'

describe 'apache2::mod_ssl' do
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
        it_should_behave_like 'an apache2 module', 'ssl', true
      end
    end
  end
end
