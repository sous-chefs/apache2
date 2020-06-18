require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#apache_libexec_dir' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
      allow(subject).to receive(:[]).with('kernel').and_return('machine' => machine)
    end
    context 'x86_64' do
      let(:machine) { 'x86_64' }

      context 'redhat' do
        let(:platform_family) { 'rhel' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib64/httpd/modules' }
      end

      context 'fedora' do
        let(:platform_family) { 'fedora' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib64/httpd/modules' }
      end

      context 'amazon' do
        let(:platform_family) { 'amazon' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib64/httpd/modules' }
      end

      context 'suse' do
        let(:platform_family) { 'suse' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib64/apache2' }
      end

      context 'debian' do
        let(:platform_family) { 'debian' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/apache2/modules' }
      end

      context 'arch' do
        let(:platform_family) { 'arch' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/httpd/modules' }
      end

      context 'freebsd' do
        let(:platform_family) { 'freebsd' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/local/libexec/apache24' }
      end
    end

    context 'x86' do
      let(:machine) { 'i686' }

      context 'redhat' do
        let(:platform_family) { 'rhel' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/httpd/modules' }
      end

      context 'fedora' do
        let(:platform_family) { 'fedora' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/httpd/modules' }
      end

      context 'amazon' do
        let(:platform_family) { 'amazon' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/httpd/modules' }
      end

      context 'suse' do
        let(:platform_family) { 'suse' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/apache2' }
      end

      context 'debian' do
        let(:platform_family) { 'debian' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/apache2/modules' }
      end

      context 'arch' do
        let(:platform_family) { 'arch' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/lib/httpd/modules' }
      end

      context 'freebsd' do
        let(:platform_family) { 'freebsd' }
        it { expect(subject.apache_libexec_dir).to eq '/usr/local/libexec/apache24' }
      end
    end
  end
end
