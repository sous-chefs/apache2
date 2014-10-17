require 'spec_helper'

# not supported modules: log_forensic
loggers_modules_without_config = %w(log_config logio)
loggers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms.select { |key, _| %w(redhat fedora suse freebsd).include?(key) }
  end
end
