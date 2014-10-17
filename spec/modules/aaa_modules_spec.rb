require 'spec_helper'

# not supported modules: authn_alias authn_anon authn_dbd authn_dbm authn_default authz_dbm authz_ldap authz_owner
aaa_modules_without_config = %w(auth_basic auth_digest authz_core authz_groupfile authz_host authz_user authn_file)
aaa_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
