name		 'apache2_test'
maintainer       'Andrew Crump'
maintainer_email 'andrew@kotirisoftware.com'
license          'Apache 2.0'
description      'Acceptance tests for apache2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends          'apache2'
depends          'jpackage'
depends          'openldap'
depends          'tomcat'
depends          'yum-epel'

recipe           'apache2_test::default', 'Test example for default recipe'
recipe           'apache2_test::mod_auth_basic', 'Test example for basic authentication'
recipe           'apache2_test::mod_auth_digest', 'Test example for digest authentication'
recipe           'apache2_test::mod_auth_openid', 'Test example for openid authentication'
recipe           'apache2_test::mod_authnz_ldap', 'Test example for LDAP authentication'
recipe           'apache2_test::mod_authz_groupfile', 'Test example for group file authorization'
recipe           'apache2_test::mod_authz_listed_host', 'Test example for host-based authorization'
recipe           'apache2_test::mod_authz_unlisted_host', 'Test example for hosted-based authorization'
recipe           'apache2_test::mod_authz_user', 'Test example for named user authorization'
recipe           'apache2_test::mod_cgi', 'Test example for hosting a CGI script'
recipe           'apache2_test::mod_expires', 'Test example for setting cache expiry headers'
recipe           'apache2_test::mod_dav_svn', 'Test example for Subversion repository hosting'
recipe           'apache2_test::mod_perl', 'Test example for hosting a Perl application'
recipe           'apache2_test::mod_proxy_ajp', 'Test example for proxying requests to a Java application'
recipe           'apache2_test::mod_php5', 'Test example for hosting a PHP application'
recipe           'apache2_test::mod_python', 'Test example for hosting a Python application'
recipe           'apache2_test::mod_ssl', 'Test example for SSL'
recipe           'apache2_test::mod_status_remote', 'Test example for viewing server status'

%w{centos ubuntu}.each do |os|
  supports os
end
