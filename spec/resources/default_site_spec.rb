require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_module, :apache2_install, :apache2_conf, :apache2_mod, :apache2_default_site
  platform 'ubuntu'

  context 'Enable the default site' do
    recipe do
      apache2_install 'default'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end

      apache2_default_site ''
    end

    it 'Creates the default site template' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/sites-available/default-site.conf')
        .with_content(%r{DocumentRoot /var/www/html})
    end
  end
end
