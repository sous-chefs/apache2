require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#apache_mod_auth_cas_install_method' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'redhat 8' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '8.2.2004' }
      it { expect(subject.apache_mod_auth_cas_install_method).to eq 'source' }
    end

    context 'redhat 7' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '7.7.1908' }
      it { expect(subject.apache_mod_auth_cas_install_method).to eq 'package' }
    end

    context 'debian' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '10' }
      it { expect(subject.apache_mod_auth_cas_install_method).to eq 'package' }
    end

    context 'ubuntu' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '20.04' }
      it { expect(subject.apache_mod_auth_cas_install_method).to eq 'package' }
    end

    context 'amazonlinux' do
      let(:platform_family) { 'amazon' }
      let(:platform_version) { '2018.03' }
      it { expect(subject.apache_mod_auth_cas_install_method).to eq 'package' }
    end

    context 'suse' do
      let(:platform_family) { 'suse' }
      let(:platform_version) { '15.1' }
      it { expect(subject.apache_mod_auth_cas_install_method).to eq 'source' }
    end
  end

  describe '#apache_mod_auth_cas_devel_packages' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'redhat 8' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '8.2.2004' }
      it { expect(subject.apache_mod_auth_cas_devel_packages).to eq %w(openssl-devel libcurl-devel pcre-devel libtool) }
    end

    context 'redhat 7' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '7.7.1908' }
      it { expect(subject.apache_mod_auth_cas_devel_packages).to eq %w(openssl-devel libcurl-devel pcre-devel libtool) }
    end

    context 'debian' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '10' }
      it { expect(subject.apache_mod_auth_cas_devel_packages).to eq %w(libssl-dev libcurl4-openssl-dev libpcre++-dev libtool) }
    end

    context 'ubuntu' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '20.04' }
      it { expect(subject.apache_mod_auth_cas_devel_packages).to eq %w(libssl-dev libcurl4-openssl-dev libpcre++-dev libtool) }
    end

    context 'amazonlinux' do
      let(:platform_family) { 'amazon' }
      let(:platform_version) { '2018.03' }
      it { expect(subject.apache_mod_auth_cas_devel_packages).to eq %w(openssl-devel libcurl-devel pcre-devel libtool) }
    end

    context 'suse' do
      let(:platform_family) { 'suse' }
      let(:platform_version) { '15.1' }
      it { expect(subject.apache_mod_auth_cas_devel_packages).to eq %w(libopenssl-devel libcurl-devel pcre-devel libtool) }
    end
  end
end
