require 'spec_helper'

describe 'apache2::mod_authn_core' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version) do
          end.converge(described_recipe)
        end
        property = load_platform_properties(:platform => platform, :platform_version => version)

        before do
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
        end

        if property[:apache][:version] == '2.2'
          it 'writes to the log' do
            expect(chef_run).to write_log('Ignoring apache2::mod_authn_core. not available until apache 2.4')
          end
        elsif property[:apache][:version] == '2.4'
          # it_should_behave_like 'an apache2 module', 'authn_core', false, supported_platforms
        end
      end
    end
  end
end
