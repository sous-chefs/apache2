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
            end.converge(described_recipe)
          end

          # separate test for opensuse as it distributes packages with workers compiled into the httpd bin
          if platform == 'opensuse'
            it "uninstalls #{(mpm_modules - [mpm]).map { |m| "apache2-#{m}" }.join ' and '} packages and installs apache2-#{mpm} package" do
              expect(chef_run).to remove_package((mpm_modules - [mpm]).map { |m| "apache2-#{m}" })
              expect(chef_run).to install_package("apache2-#{mpm}")
            end
          else
            it_should_behave_like 'an apache2 module', "mpm_#{mpm}", true, nil, true
          end
        end
      end
    end
  end
end
