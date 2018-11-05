require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#perl_pkg' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'with rhel family' do
      let(:platform_family) { 'rhel' }

      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl'
      end
    end

    context 'with fedora family' do
      let(:platform_family) { 'fedora' }

      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl'
      end
    end

    context 'with amazon family' do
      let(:platform_family) { 'amazon' }

      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl'
      end
    end

    context 'with SUSE family' do
      let(:platform_family) { 'suse' }

      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl'
      end
    end

    context 'with Debian' do
      let(:platform_family) { 'debian' }
      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl'
      end
    end

    context 'with arch' do
      let(:platform_family) { 'arch' }
      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl'
      end
    end

    context 'with freebsd' do
      let(:platform_family) { 'freebsd' }
      it 'returns the correct path' do
        expect(subject.perl_pkg).to eq 'perl5'
      end
    end
  end
end

describe '#apache_pkg' do
  recipe do
    log apache_pkg
  end

  context 'with rhel family' do
    platform 'redhat'
    it { is_expected.to write_log('httpd') }
  end

  context 'with fedora family' do
    platform 'fedora'
    it { is_expected.to write_log('httpd') }
  end

  context 'with amazon family' do
    context 'on amazon-1' do
      platform 'amazon', '2018'
      it { is_expected.to write_log('httpd24') }
    end

    context 'on amazon-2' do
      platform 'amazon', '2'
      it { is_expected.to write_log('httpd') }
    end
  end

  context 'with SUSE family' do
    platform 'suse'
    it { is_expected.to write_log('apache2') }
  end

  context 'with Debian' do
    platform 'debian'
    it { is_expected.to write_log('apache2') }
  end

  context 'with arch' do
    platform 'arch'
    it { is_expected.to write_log('apache') }
  end

  context 'with freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('apache24') }
  end
end
