require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2'],
  'suse' => ['11.3']
}
#  'arch' =>

describe 'apache2::mod_auth_basic' do
  platforms.each do |platform, versions|
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

  it_should_behave_like 'an apache2 module', 'fcgid', true, platforms
end
