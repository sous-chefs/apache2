require 'spec_helper'

platforms = supported_platforms.select { |key, _| %w(debian ubuntu).include?(key) }

describe 'apache2::mod_pagespeed' do
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before do
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
        end

        it 'installs package mod_pagespeed' do
          expect(chef_run).to install_package('mod_pagespeed')
          expect(chef_run).to_not install_package('not_mod_pagespeed')
        end
      end
    end
  end
  it_should_behave_like 'an apache2 module', 'pagespeed', true, platforms
  # it 'raises an exception' do
  #   expect { chef_run }
  #      .to raise_error(RuntimeError, "`mac_os_x' is not supported!")
  # end
end
