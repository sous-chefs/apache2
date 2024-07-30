require 'spec_helper'

describe 'apache2_mod_php' do
  step_into :apache2_install, :apache2_mod_php, :apache2_module

  platform 'ubuntu'

  context 'Setup and enable PHP module' do
    recipe do
      apache2_install 'phptest'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_mod_php 'phptest'
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to install_package('libapache2-mod-php')
    end

    it do
      is_expected.to create_template('/etc/apache2/mods-available/php.conf')
    end

    it do
      is_expected.to enable_apache2_module('php').with(
        identifier: 'php_module',
        mod_name: 'libphp8.1.so'
      )
    end
  end

  context 'Enable PHP module with custom properties' do
    recipe do
      apache2_install 'phpcustom'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_mod_php 'phpcustom' do
        module_name 'phptest_module'
        so_filename 'libphptest.so'
        package_name 'mod_phptest'
      end
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to install_package('mod_phptest')
    end

    it do
      is_expected.to enable_apache2_module('php').with(
        identifier: 'phptest_module',
        mod_name: 'libphptest.so'
      )
    end
  end

  context 'Do not install module package' do
    recipe do
      apache2_install 'phpcustom'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_mod_php 'phpcustom' do
        package_name 'mod_phptest'
        install_package false
      end
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to_not install_package('mod_phptest')
    end
  end
end
