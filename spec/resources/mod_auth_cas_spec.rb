require 'spec_helper'

describe 'apache2_mod_auth_cas' do
  step_into :apache2_install, :apache2_mod_auth_cas
  platform 'ubuntu'

  context 'install mod auth cas' do
    recipe do
      apache2_install 'package'

      apache2_mod_auth_cas 'package_install'

      apache2_mod_auth_cas 'source_install' do
        install_method 'source'
      end
    end

    it do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      stub_command('test -f /usr/lib/apache2/modules/mod_auth_cas.so').and_return('0')

      is_expected.to install_package('libapache2-mod-auth-cas')
      is_expected.not_to install_package('mod_auth_cas')
    end

    it 'Creates the load template with the correct cach directory' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      stub_command('test -f /usr/lib/apache2/modules/mod_auth_cas.so').and_return('bar')

      is_expected.to create_template('/etc/apache2/mods-available/auth_cas.load').with_variables(
        cache_dir: '/var/cache/apache2'
      )
    end
  end
end
