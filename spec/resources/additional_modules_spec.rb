# frozen_string_literal: true

require 'spec_helper'

describe 'apache2_mod_info' do
  step_into :apache2_mod_info
  platform 'ubuntu', '24.04'

  recipe do
    apache2_mod_info 'info'
  end

  it { is_expected.to render_file('/etc/apache2/mods-available/info.conf').with_content('SetHandler server-info') }
end

describe 'apache2_mod_userdir' do
  step_into :apache2_mod_userdir
  platform 'ubuntu', '24.04'

  recipe do
    apache2_mod_userdir 'userdir'
  end

  it { is_expected.to render_file('/etc/apache2/mods-available/userdir.conf').with_content('/home/*/public_html') }
end
