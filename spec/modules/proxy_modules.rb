require 'spec_helper'

# not supported modules: proxy_ftp proxy_scgi
proxy_modules_without_config = %w(proxy_ajp proxy_connect proxy_http)
proxy_modules_with_config = %w(proxy proxy_balancer)
proxy_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    supported_platforms.each do |platform, versions|
      versions.each do |version|
        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        let(:chef_run) do
          @chef_run
        end

        context "on #{platform.capitalize} #{version}" do
          it_should_behave_like 'an apache2 module', mod, false
        end
      end
    end
  end
end
proxy_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    supported_platforms.each do |platform, versions|
      versions.each do |version|
        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        let(:chef_run) do
          @chef_run
        end

        context "on #{platform.capitalize} #{version}" do
          it_should_behave_like 'an apache2 module', mod, true
        end
      end
    end
  end
end
