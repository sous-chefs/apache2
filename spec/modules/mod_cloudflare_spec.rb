require 'spec_helper'

platforms = supported_platforms.select { |key, _| %w(debian ubuntu redhat centos fedora).include?(key) }

describe 'apache2::mod_cloudflare' do
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        if %w(debian ubuntu).include?(platform)
          pkg = 'libapache2-mod-cloudflare'
          it "installs package #{pkg}" do
            expect(chef_run).to install_package(pkg)
            expect(chef_run).to_not install_package("not_#{pkg}")
          end
        end
        if %w(redhat centos fedora).include?(platform)
          pkg = 'mod_cloudflare'
          it "installs package #{pkg}" do
            expect(chef_run).to install_package(pkg)
            expect(chef_run).to_not install_package("not_#{pkg}")
          end
        end

        it_should_behave_like 'an apache2 module', 'cloudflare', false
      end
    end
  end
end
