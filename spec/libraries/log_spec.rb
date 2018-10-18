require 'spec_helper'

describe '#default_error_log' do
  recipe do
    log default_error_log
  end

  context 'with rhel family' do
    platform 'redhat'
    it { is_expected.to write_log('error.log') }
  end

  context 'with fedora family' do
    platform 'fedora'
    it { is_expected.to write_log('error.log') }
  end

  context 'with amazon family' do
    platform 'amazon'
    it { is_expected.to write_log('error.log') }
  end

  context 'with SUSE family' do
    platform 'suse'
    it { is_expected.to write_log('error.log') }
  end

  context 'with Debian' do
    platform 'debian'
    it { is_expected.to write_log('error.log') }
  end

  context 'with arch' do
    platform 'arch'
    it { is_expected.to write_log('error.log') }
  end

  context 'with freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('httpd-error.log') }
  end
end

describe '#default_access_log' do
  recipe do
    log default_access_log
  end

  context 'with rhel family' do
    platform 'redhat'
    it { is_expected.to write_log('access.log') }
  end

  context 'with fedora family' do
    platform 'fedora'
    it { is_expected.to write_log('access.log') }
  end

  context 'with amazon family' do
    platform 'amazon'
    it { is_expected.to write_log('access.log') }
  end

  context 'with SUSE family' do
    platform 'suse'
    it { is_expected.to write_log('access.log') }
  end

  context 'with Debian' do
    platform 'debian'
    it { is_expected.to write_log('access.log') }
  end

  context 'with arch' do
    platform 'arch'
    it { is_expected.to write_log('access.log') }
  end

  context 'with freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('httpd-access.log') }
  end
end
