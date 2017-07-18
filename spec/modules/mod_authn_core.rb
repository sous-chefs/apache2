require 'spec_helper'

describe 'apache2::mod_authn_core' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version) do
          end.converge(described_recipe)
        end
        property = load_platform_properties(platform: platform, platform_version: version)

        before do
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
        end

        # it_should_behave_like 'an apache2 module', 'authn_core', false
      end
    end
  end
end
