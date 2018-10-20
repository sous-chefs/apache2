require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_module, :apache2_install
  platform 'ubuntu'

  context 'install an apache2_module with default properties' do

    recipe do
      apache2_install 'default'
      apache2_module 'test'
    end

    it 'Creates a LoadModule file with the correct path' do
      stub_command("/usr/sbin/apache2 -t").and_return('foo')

      is_expected.to create_file('/etc/apache2/mods-available/test.load').with_content(%r{/usr/lib/apache2/modules/mod_test.so})
    end

  end
end
