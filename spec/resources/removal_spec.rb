# frozen_string_literal: true

require 'spec_helper'

%w(actions alias autoindex cache_disk cgid dav_fs deflate dir fastcgi fcgid include info ldap mime mime_magic mpm_event mpm_prefork mpm_worker negotiation proxy proxy_balancer proxy_ftp reqtimeout setenvif status userdir).each do |mod|
  describe "apache2_mod_#{mod} removal" do
    step_into "apache2_mod_#{mod}".to_sym
    platform 'ubuntu', '24.04'

    recipe do
      declare_resource("apache2_mod_#{mod}", 'remove') do
        action :delete
      end
    end

    it { is_expected.to delete_file("/etc/apache2/mods-available/#{mod}.conf") }
    it { is_expected.to delete_link("/etc/apache2/mods-enabled/#{mod}.conf") }
  end
end

describe 'apache2_install removal' do
  step_into :apache2_install
  platform 'ubuntu', '24.04'

  recipe do
    apache2_install 'remove' do
      action :remove
    end
  end

  it { is_expected.to stop_systemd_unit('apache2.service') }
  it { is_expected.to disable_systemd_unit('apache2.service') }
  it { is_expected.to remove_package(%w(apache2 perl)) }
  it { is_expected.to delete_directory('/etc/apache2').with(recursive: true) }
  it { is_expected.to delete_directory('/var/log/apache2').with(recursive: true) }
  it { is_expected.to delete_file('/usr/sbin/a2enmod') }
  it { is_expected.to delete_link('/usr/sbin/a2ensite') }
  it { is_expected.to delete_apache2_module('status') }
end

describe 'apache2_module removes resources used by enable' do
  step_into :apache2_module
  platform 'ubuntu', '24.04'

  recipe do
    apache2_module 'ssl' do
      action :delete
    end
  end

  it { is_expected.to delete_apache2_mod_ssl('default') }
end

describe 'apache2_module removal' do
  step_into :apache2_module
  platform 'ubuntu', '24.04'

  recipe do
    apache2_module 'headers' do
      action :delete
    end
  end

  %w(conf load).each do |extension|
    it { is_expected.to delete_link("/etc/apache2/mods-enabled/headers.#{extension}") }
    it { is_expected.to delete_file("/etc/apache2/mods-available/headers.#{extension}") }
  end
end
