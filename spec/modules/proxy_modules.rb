require 'spec_helper'

# not supported modules: proxy_ftp proxy_scgi
proxy_modules_without_config = %w(proxy_ajp proxy_connect proxy_http)
proxy_modules_with_config = %w(proxy proxy_balancer)
proxy_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
proxy_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end
