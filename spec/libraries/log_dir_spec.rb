require 'spec_helper'

describe '#log_dir' do
  recipe do
    log default_log_dir
  end

  context 'with rhel family' do
    platform 'redhat'
    it { is_expected.to write_log('/var/log/httpd') }
  end

  context 'with fedora family' do
    platform 'fedora'
    it { is_expected.to write_log('/var/log/httpd') }
  end

  context 'with amazon family' do
    platform 'amazon'
    it { is_expected.to write_log('/var/log/httpd') }
  end

  context 'with SUSE family' do
    platform 'suse'
    it { is_expected.to write_log('/var/log/apache2') }
  end

  context 'with Debian' do
    platform 'debian'
    it { is_expected.to write_log('/var/log/apache2') }
  end

  context 'with arch' do
    platform 'arch'
    it { is_expected.to write_log('/var/log/httpd') }
  end

  context 'with freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('/var/log') }
  end
end
