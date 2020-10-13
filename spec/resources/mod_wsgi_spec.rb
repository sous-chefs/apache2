require 'spec_helper'

describe 'apache2_mod_wsgi' do
  step_into :apache2_install, :apache2_mod_wsgi, :apache2_module

  platform 'ubuntu'

  context 'Setup and enable WSGI module' do
    recipe do
      apache2_install 'wsgitest'
      apache2_mod_wsgi 'wsgitest'
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to install_package('libapache2-mod-wsgi-py3')
    end

    it do
      is_expected.to enable_apache2_module('wsgi').with(
        identifier: 'wsgi_module',
        mod_name: 'mod_wsgi.so'
      )
    end
  end

  context 'Enable WSGI module with custom properties' do
    recipe do
      apache2_install 'wsgicustom'
      apache2_mod_wsgi 'wsgicustom' do
        module_name 'wsgitest_module'
        so_filename 'libwsgitest.so'
        package_name 'mod_wsgitest'
      end
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to install_package('mod_wsgitest')
    end

    it do
      is_expected.to enable_apache2_module('wsgi').with(
        identifier: 'wsgitest_module',
        mod_name: 'libwsgitest.so'
      )
    end
  end

  context 'Do not install module package' do
    recipe do
      apache2_install 'wsgicustom'
      apache2_mod_wsgi 'wsgicustom' do
        package_name 'mod_wsgitest'
        install_package false
      end
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to_not install_package('mod_wsgitest')
    end
  end
end
