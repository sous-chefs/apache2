require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_mod_setenvif, :apache2_mod_reqtimeout, :apache2_mod_proxy
  platform 'ubuntu'

  context 'mod_setenvif' do
    recipe do
      apache2_mod_setenvif ''
    end

    it 'outputs the setenvif template with the correctly escaped content' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_setenvif.conf').with_content(
        %r{BrowserMatch "Konqueror/4" redirect-carefully}
      )
    end
  end

  context 'mod_reqtimeout' do
    recipe do
      apache2_mod_reqtimeout ''
    end

    it 'outputs the reqtimeout template with the correct hash values only' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_reqtimeout.conf').with_content(
        %r{header=20-40,minrate=500}
      )

      is_expected.to render_file('/etc/apache2/mods-available/mod_reqtimeout.conf').with_content(
        %r{body=10,minrate=500}
      )
    end
  end

  context 'mod_proxy' do
    recipe do
      apache2_mod_proxy ''
    end

    it 'outputs the proxy template with the correct values' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_proxy.conf').with_content(
        %r{ProxyRequests Off}
      )
    end
  end


end
