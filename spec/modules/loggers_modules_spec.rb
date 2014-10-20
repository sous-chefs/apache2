require 'spec_helper'

# not supported modules: log_forensic
loggers_modules_without_config = %w(log_config logio)
loggers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    supported_platforms.select { |key, _| %w(redhat fedora suse freebsd).include?(key) }.each do |platform, versions|
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
          it_should_behave_like 'an apache2 module', mod, false
        end
      end
    end
  end
end
