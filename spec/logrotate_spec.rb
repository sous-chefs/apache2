require 'spec_helper'

describe 'apache2::logrotate' do

  # Test all defaults on all platforms
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        # apache_service = service 'apache2' do
        #   action :nothing
        # end
        it 'includes the `logrotate` recipe' do
          expect(chef_run).to include_recipe('logrotate')
        end
        # logrotate_app apache_service.service_name do
        #   path property[:apache][:log_dir]
        # end
      end
    end
  end
end
