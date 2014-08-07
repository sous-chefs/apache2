require 'spec_helper'

describe 'apache2::mod_auth_basic' do
  it_should_behave_like 'an apache2 module', 'fcgid', true, supported_platforms
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version) do
          end.converge(described_recipe)
        end

        it 'installs apache2-utils' do
          expect(chef_run).to install_package('apache2-utils')
        end if %w(ubuntu debian).include?(platform) && version == '14.04'
      end
    end
  end
end
