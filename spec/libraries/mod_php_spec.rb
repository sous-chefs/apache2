require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#apache_mod_php_filename' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
      allow(subject).to receive(:[]).with('platform').and_return(platform)
      allow(subject).to receive(:[]).with(:platform).and_return(platform)
    end

    context 'debian 12' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'debian' }
      let(:platform_version) { '12' }
      it { expect(subject.apache_mod_php_filename).to eq 'libphp8.2.so' }
    end

    context 'debian 13' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'debian' }
      let(:platform_version) { '13' }
      it { expect(subject.apache_mod_php_filename).to eq 'libphp8.4.so' }
    end

    context 'ubuntu 22.04' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '22.04' }
      it { expect(subject.apache_mod_php_filename).to eq 'libphp8.1.so' }
    end

    context 'ubuntu 24.04' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '24.04' }
      it { expect(subject.apache_mod_php_filename).to eq 'libphp8.3.so' }
    end

    context 'opensuse 15.5' do
      let(:platform_family) { 'suse' }
      let(:platform) { 'opensuse' }
      let(:platform_version) { '15.5' }
      it { expect(subject.apache_mod_php_filename).to eq 'mod_php8.so' }
    end
  end

  describe '#apache_mod_php_modulename' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
      allow(subject).to receive(:[]).with('platform').and_return(platform)
      allow(subject).to receive(:[]).with(:platform).and_return(platform)
    end

    context 'debian 12' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'debian' }
      let(:platform_version) { '12' }
      it { expect(subject.apache_mod_php_modulename).to eq 'php_module' }
    end

    context 'debian 13' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'debian' }
      let(:platform_version) { '13' }
      it { expect(subject.apache_mod_php_modulename).to eq 'php_module' }
    end

    context 'ubuntu 22.04' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '22.04' }
      it { expect(subject.apache_mod_php_modulename).to eq 'php_module' }
    end

    context 'ubuntu 24.04' do
      let(:platform_family) { 'debian' }
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '24.04' }
      it { expect(subject.apache_mod_php_modulename).to eq 'php_module' }
    end
  end
end
