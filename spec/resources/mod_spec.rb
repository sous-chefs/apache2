require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_mod_setenvif
  platform 'ubuntu'

  context 'install apache2 with default properties' do
    recipe do
      apache2_mod_setenvif ''
    end

    it 'outputs the setenvif template with the correctly escaped content' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_setenvif.conf').with_content(
        %r{BrowserMatch "Konqueror/4" redirect-carefully}
      )
    end
  end
end
