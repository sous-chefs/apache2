# frozen_string_literal: true

require 'spec_helper'

describe 'apache2_mod_ssl' do
  step_into :apache2_mod_ssl
  platform 'ubuntu'

  context 'mod_ssl default' do
    recipe do
      apache2_mod_ssl 'default'
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('OK')
    end

    it { is_expected.to create_template('/etc/apache2/mods-available/ssl.conf') }
  end
end
