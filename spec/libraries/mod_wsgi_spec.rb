require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#apache_mod_wsgi_package' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'redhat 8' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '8' }
      it { expect(subject.apache_mod_wsgi_package).to eq 'python3-mod_wsgi' }
    end

    context 'redhat 7' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '7' }
      it { expect(subject.apache_mod_wsgi_package).to eq 'mod_wsgi' }
    end

    context 'debian' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '11' }
      it { expect(subject.apache_mod_wsgi_package).to eq 'libapache2-mod-wsgi-py3' }
    end

    context 'ubuntu' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '22.04' }
      it { expect(subject.apache_mod_wsgi_package).to eq 'libapache2-mod-wsgi-py3' }
    end

    context 'amazonlinux' do
      let(:platform_family) { 'amazon' }
      let(:platform_version) { '2023' }
      it { expect(subject.apache_mod_wsgi_package).to eq nil }
    end

    context 'suse' do
      let(:platform_family) { 'suse' }
      let(:platform_version) { '15.1' }
      it { expect(subject.apache_mod_wsgi_package).to eq 'apache2-mod_wsgi-python3' }
    end
  end

  describe '#apache_mod_wsgi_filename' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'redhat 8' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '8.2.2004' }
      it { expect(subject.apache_mod_wsgi_filename).to eq 'mod_wsgi_python3.so' }
    end

    context 'redhat 7' do
      let(:platform_family) { 'rhel' }
      let(:platform_version) { '7.7.1908' }
      it { expect(subject.apache_mod_wsgi_filename).to eq 'mod_wsgi.so' }
    end

    context 'debian' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '10' }
      it { expect(subject.apache_mod_wsgi_filename).to eq 'mod_wsgi.so' }
    end

    context 'ubuntu' do
      let(:platform_family) { 'debian' }
      let(:platform_version) { '20.04' }
      it { expect(subject.apache_mod_wsgi_filename).to eq 'mod_wsgi.so' }
    end

    context 'amazonlinux' do
      let(:platform_family) { 'amazon' }
      let(:platform_version) { '2018.03' }
      it { expect(subject.apache_mod_wsgi_filename).to eq 'mod_wsgi.so' }
    end

    context 'suse' do
      let(:platform_family) { 'suse' }
      let(:platform_version) { '15.1' }
      it { expect(subject.apache_mod_wsgi_filename).to eq 'mod_wsgi.so' }
    end
  end
end
