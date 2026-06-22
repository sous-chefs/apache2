require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#perl_pkg' do
    before do
      allow(subject).to receive(:[]).with(:platform_family).and_return(platform_family)
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
  end
end

describe '#default_apache_pkg' do
  recipe do
    log default_apache_pkg
  end

  context 'with fedora family' do
    platform 'fedora'
    it { is_expected.to write_log('httpd') }
  end

  context 'with amazon family' do
    platform 'amazon', '2'
    it { is_expected.to write_log('httpd') }
  end

  context 'with SUSE family' do
    platform 'suse'
    it { is_expected.to write_log('apache2') }
  end

  context 'with Debian' do
    platform 'debian'
    it { is_expected.to write_log('apache2') }
  end
end
