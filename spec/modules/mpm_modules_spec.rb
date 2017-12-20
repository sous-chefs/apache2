require 'spec_helper'

mpm_modules = %w(event prefork worker)

mpm_modules.each do |mpm|
  describe "apache2::mpm_#{mpm}" do
    supported_platforms.each do |platform, versions|
      versions.each do |version|
        property = load_platform_properties(platform: platform, platform_version: version)

        context "on #{platform.capitalize} #{version}" do
          let(:chef_run) do
            ChefSpec::SoloRunner.new(platform: platform, version: version) do
              stub_command("#{property[:apache][:binary]} -t").and_return(true)
            end.converge('apache2::default', described_recipe)
          end

          # separate test for opensuse as it distributes packages with workers compiled into the httpd bin
          if platform == 'opensuse'
            it "uninstalls #{(mpm_modules - [mpm]).map { |m| "apache2-#{m}" }.join ' and '} packages" do
              (mpm_modules - [mpm]).map { |m| "apache2-#{m}" }.each do |pkg|
                expect(chef_run).to remove_rpm_package(pkg)
                expect(chef_run.rpm_package(pkg)).to notify('service[apache2]').to(:restart)
              end
              expect(chef_run).to create_link('/usr/sbin/httpd').with(to: "/usr/sbin/httpd-#{mpm}")
              expect(chef_run.link('/usr/sbin/httpd')).to notify('service[apache2]').to(:restart)
            end
          else
            it_should_behave_like 'an apache2 module', "mpm_#{mpm}", true, nil, true
          end
        end
      end
    end
  end
end
