require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_module, :apache2_install, :apache2_conf, :apache2_mod
  platform 'ubuntu'

  context 'install an apache2_module with default properties' do
    recipe do
      apache2_install 'default'
      apache2_module 'sed'
    end

    it 'Creates a LoadModule file with the correct path' do
      stub_command('/usr/sbin/apache2 -t').and_return('foo')

      is_expected.to run_execute('a2enmod sed')
    end
  end
end
