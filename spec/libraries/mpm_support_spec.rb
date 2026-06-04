
require 'spec_helper'

describe '#mpm_support' do
  recipe do
    log default_mpm
  end

  context 'redhat' do
    platform 'redhat'
    it { is_expected.to write_log('event') }
  end

  context 'fedora' do
    platform 'fedora'
    it { is_expected.to write_log('event') }
  end

  context 'amazon' do
    platform 'amazon'
    it { is_expected.to write_log('event') }
  end

  context 'suse' do
    platform 'suse'
    it { is_expected.to write_log('event') }
  end

  context 'debian' do
    platform 'debian'
    it { is_expected.to write_log('event') }
  end
  context 'ubuntu' do
    platform 'ubuntu'
    it { is_expected.to write_log('event') }
  end
end
