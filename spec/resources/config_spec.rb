require 'spec_helper'

describe 'apache2_config' do
  step_into :apache2_config
  platform 'ubuntu'

  context 'install config template from external' do
    recipe do
      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_config 'apache2.conf' do
        template_cookbook 'test'
        error_log '"| /usr/sbin/rotatelogs /var/log/error_log.%Y%m%d"'
      end
    end

    it 'Creates a template from the specified cookbook' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/apache2.conf')
        .with_content('ErrorLog "| /usr/sbin/rotatelogs /var/log/error_log.%Y%m%d"')
    end
  end
end
