require 'spec_helper'

# not supported modules: dbd
database_modules_without_config = %w()
database_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
