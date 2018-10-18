require 'spec_helper'

describe '#apache_pid_file' do
  recipe do
    log apache_pid_file
  end

  context 'with rhel family' do
    platform 'redhat'
    it { is_expected.to write_log('/var/run/httpd/httpd.pid') }
  end

  context 'with fedora family' do
    platform 'fedora'
    it { is_expected.to write_log('/var/run/httpd/httpd.pid') }
  end

  context 'with amazon family' do
    platform 'amazon'
    it { is_expected.to write_log('/var/run/httpd/httpd.pid') }
  end

  context 'with SUSE family' do
    platform 'suse'
    it { is_expected.to write_log('/var/run/httpd2.pid') }
  end

  context 'with Debian' do
    platform 'debian'
    it { is_expected.to write_log('/var/run/apache2/apache2.pid') }
  end

  context 'with arch' do
    platform 'arch'
    it { is_expected.to write_log('/var/run/httpd/httpd.pid') }
  end

  context 'with freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('/var/run/httpd.pid') }
  end
end
