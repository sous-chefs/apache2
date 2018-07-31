require 'spec_helper'
require_relative '../../libraries/helpers'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#apache_binary' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'with rhel family' do
      let(:platform_family) { 'rhel' }

      it 'returns the correct path' do
        expect(subject.apache_binary).to eq '/usr/sbin/httpd'
      end
    end

    context 'with SUSE family' do
      let(:platform_family) { 'suse' }

      it 'returns the correct path' do
        expect(subject.apache_binary).to eq '/usr/sbin/httpd'
      end
    end

    context 'with Debian' do
      let(:platform_family) { 'debian' }
      it 'returns the correct path' do
        expect(subject.apache_binary).to eq '/usr/sbin/apache2'
      end
    end

    context 'with arch' do
      let(:platform_family) { 'arch' }
      it 'returns the correct path' do
        expect(subject.apache_binary).to eq '/usr/sbin/httpd'
      end
    end

    context 'with freebsd' do
      let(:platform_family) { 'freebsd' }
      it 'returns the correct path' do
        expect(subject.apache_binary).to eq '/usr/local/sbin/httpd'
      end
    end
  end

  describe '#platform_service_name' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'with rhel family' do
      let(:platform_family) { 'rhel' }

      it 'returns the correct service name' do
        expect(subject.platform_service_name).to eq 'httpd'
      end
    end

    context 'with amazon family' do
      let(:platform_family) { 'amazon' }

      it 'returns the correct service name' do
        expect(subject.platform_service_name).to eq 'httpd'
      end
    end

    context 'with SUSE family' do
      let(:platform_family) { 'suse' }

      it 'returns the correct service name' do
        expect(subject.platform_service_name).to eq 'apache2'
      end
    end

    context 'with Debian' do
      let(:platform_family) { 'debian' }
      it 'returns the correct service name' do
        expect(subject.platform_service_name).to eq 'apache2'
      end
    end

    context 'with arch' do
      let(:platform_family) { 'arch' }
      it 'returns the correct service name' do
        expect(subject.platform_service_name).to eq 'httpd'
      end
    end

    context 'with freebsd' do
      let(:platform_family) { 'freebsd' }
      it 'returns the correct service name' do
        expect(subject.platform_service_name).to eq 'apache24'
      end
    end
  end

  describe '#apachectl binary name' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'with rhel family' do
      let(:platform_family) { 'rhel' }

      it 'returns the correct apachectl binary' do
        expect(subject.apachectl).to eq '/usr/sbin/apachectl'
      end
    end

    context 'with amazon family' do
      let(:platform_family) { 'amazon' }

      it 'returns the correct apachectl binary' do
        expect(subject.apachectl).to eq '/usr/sbin/apachectl'
      end
    end

    context 'with SUSE family' do
      let(:platform_family) { 'suse' }

      it 'returns the correct apachectl binary' do
        expect(subject.apachectl).to eq '/usr/sbin/apache2ctl'
      end
    end

    context 'with Debian' do
      let(:platform_family) { 'debian' }
      it 'returns the correct apachectl binary' do
        expect(subject.apachectl).to eq '/usr/sbin/apache2ctl'
      end
    end

    context 'with arch' do
      let(:platform_family) { 'arch' }
      it 'returns the correct apachectl binary' do
        expect(subject.apachectl).to eq '/usr/sbin/apachectl'
      end
    end

    context 'with freebsd' do
      let(:platform_family) { 'freebsd' }
      it 'returns the correct apachectl binary' do
        expect(subject.apachectl).to eq '/usr/local/sbin/apachectl'
      end
    end
  end

  describe '#apache directory name' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'with rhel family' do
      let(:platform_family) { 'rhel' }

      it 'returns the correct apache directory' do
        expect(subject.apache_dir).to eq '/etc/httpd'
      end
    end

    context 'with amazon family' do
      let(:platform_family) { 'amazon' }

      it 'returns the correct apache directory' do
        expect(subject.apache_dir).to eq '/etc/httpd'
      end
    end

    context 'with SUSE family' do
      let(:platform_family) { 'suse' }

      it 'returns the correct apache directory' do
        expect(subject.apache_dir).to eq '/etc/apache2'
      end
    end

    context 'with Debian' do
      let(:platform_family) { 'debian' }
      it 'returns the correct apache directory' do
        expect(subject.apache_dir).to eq '/etc/apache2'
      end
    end

    context 'with arch' do
      let(:platform_family) { 'arch' }
      it 'returns the correct apache directory' do
        expect(subject.apache_dir).to eq '/etc/httpd'
      end
    end

    context 'with freebsd' do
      let(:platform_family) { 'freebsd' }
      it 'returns the correct apache directory' do
        expect(subject.apache_dir).to eq '/usr/local/etc/apache24'
      end
    end
  end
end
