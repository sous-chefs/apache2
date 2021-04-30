require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_module, :apache2_install
  platform 'ubuntu'

  context 'install an apache2_module with default properties' do
    recipe do
      apache2_install 'default'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_module 'test'
    end

    it 'Creates a LoadModule file with the correct path' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')

      is_expected.to create_file('/etc/apache2/mods-available/test.load').with_content(%r{/usr/lib/apache2/modules/mod_test.so})
    end
  end

  context 'mod_proxy with custom configuration' do
    step_into :apache2_module, :apache2_install, :apache2_mod_proxy

    recipe do
      apache2_install 'default'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_module 'proxy' do
        mod_conf add_default_charset: 'utf-8'
      end
    end

    it 'Installs mod_proxy with custom configuration' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')

      is_expected.to create_template('/etc/apache2/mods-available/proxy.conf').with(
        variables: {
          require: 'all denied',
          proxy_via: 'On',
          proxy_requests: 'Off',
          add_default_charset: 'utf-8',
        }
      )

      is_expected.to render_file('/etc/apache2/mods-available/proxy.conf')
        .with_content(/AddDefaultCharset\s*utf-8/)
    end
  end
end
