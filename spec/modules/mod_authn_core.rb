require 'spec_helper'

describe 'apache2::mod_authn_core' do

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end
        if platform[:apache][:version] == '2.2'
          expect(chef_run).to write_log('Ignoring apache2::mod_authn_core. not available until apache 2.4')
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'authn_core', false, supported_platforms, 'mod_authn_core.so'
end
