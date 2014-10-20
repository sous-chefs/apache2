require 'spec_helper'

describe 'apache2::mod_fcgid' do
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
        it_should_behave_like 'an apache2 module', 'fcgid', true
      end
    end
  end
end
