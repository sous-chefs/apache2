require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_module, :apache2_install, :apache2_conf, :apache2_mod
  platform 'ubuntu'

  context 'install an apache2_module with default properties' do
    recipe do
      apache2_install 'default'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_module 'sed'
    end

    it 'Creates a LoadModule file with the correct path' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')

      is_expected.to run_execute('a2enmod sed')
    end

    it 'Creates the security template' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/conf-available/security.conf')
        .with_content(/ServerTokens Prod/)
        .with_content(/ServerSignature On/)
        .with_content(/TraceEnable Off/)
    end

    it 'Creates the ports template' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/ports.conf')
        .with_content(/Listen 80/)
        .with_content(/Listen 443/)
    end

    it 'Creates the charset template' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/conf-available/charset.conf')

      is_expected.not_to render_file('/etc/apache2/conf-available/charset.conf')
        .with_content(/AddDefaultCharset /)
    end
  end
end
