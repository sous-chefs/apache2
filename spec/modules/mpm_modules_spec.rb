require 'spec_helper'

mpm_modules = %w(prefork worker event)

mpm_modules.each do |mpm|
  describe "apache2::mpm_#{mpm}" do
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
          it_should_behave_like 'an apache2 module', "mpm_#{mpm}", true, nil, true
        end
      end
    end
  end
end
