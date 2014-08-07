require 'spec_helper'

describe 'apache2::mod_fcgid' do
  before do
    stub_command('/usr/sbin/httpd -t').and_return('Syntax OK')
  end

  it_should_behave_like 'an apache2 module', 'fcgid', true, supported_platforms
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version) do
          end.converge(described_recipe)
        end

        it 'includes yum-epel' do
          expect(chef_run).to include_recipe('yum-epel')
        end if %w(redhat centos).include?(platform)
      end
    end
  end
end
