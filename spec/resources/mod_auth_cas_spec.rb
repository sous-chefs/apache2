require 'spec_helper'

describe 'apache2_mod_auth_cas' do
  step_into :apache2_install, :apache2_mod_auth_cas
  recipe do
    apache2_install 'package'

    apache2_mod_auth_cas
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
          directives: nil,
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
  end
end
