require 'spec_helper'

describe 'apache2_mod_auth_cas' do
  step_into :apache2_install, :apache2_mod_auth_cas, :apache2_module
  recipe do
    apache2_install 'package'

    service 'apache2' do
      service_name lazy { apache_platform_service_name }
      supports restart: true, status: true, reload: true
      action :nothing
    end

    apache2_mod_auth_cas 'default' do
      directives(CASDebug: 'Off')
    end
  end
  context 'ubuntu' do
    platform 'ubuntu'

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return(true)
    end

    it { is_expected.to install_package('libapache2-mod-auth-cas') }

    it do
      is_expected.to enable_apache2_module('auth_cas').with(
        template_cookbook: 'apache2',
        mod_conf: {
          cache_dir: '/var/cache/apache2',
          login_url: 'https://login.example.org/cas/login',
          validate_url: 'https://login.example.org/cas/serviceValidate',
          directives: {
            'CASDebug': 'Off',
          },
        }
      )
    end

    it do
      is_expected.to create_directory('/var/cache/apache2/mod_auth_cas').with(
        owner: 'www-data',
        group: 'www-data',
        mode: '0700'
      )
    end

    [
      %r{^CASCookiePath /var/cache/apache2/mod_auth_cas/$},
      %r{^CASLoginURL https://login.example.org/cas/login$},
      %r{^CASValidateURL https://login.example.org/cas/serviceValidate$},
      /^CASDebug Off$/,
    ].each do |line|
      it { is_expected.to render_file('/etc/apache2/mods-available/auth_cas.conf').with_content(line) }
    end
  end
end
