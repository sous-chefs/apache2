require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_module, :apache2_install, :apache2_conf, :apache2_mod, :apache2_default_site
  platform 'ubuntu'

  context 'Enable the default site' do
    recipe do
      apache2_install 'default'
      apache2_default_site ''
    end

    it 'Creates the default site template' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/sites-available/default-site.conf')
        .with_content(%r{DocumentRoot /var/www/html})
    end
  end
end
