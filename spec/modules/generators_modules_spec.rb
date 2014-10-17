require 'spec_helper'

# not supported modules: asis cgid suexec
generators_modules_without_config = %w(cgi)
generators_modules_with_config = %w(autoindex status info)
generators_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
generators_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end
