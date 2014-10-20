require 'spec_helper'

# not supported modules: cern_meta ident mime_magic unique_id usertrack version
metadata_modules_without_config = %w(env expires headers)
metadata_modules_with_config = %w(setenvif)
metadata_modules_without_config.each do |mod|
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
metadata_modules_with_config.each do |mod|
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
