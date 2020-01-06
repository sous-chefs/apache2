require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#default_cache_root' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'with rhel family' do
      let('platform_family') { 'rhel' }

      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/httpd/mod_cache_disk'
      end
    end

    context 'with fedora family' do
      let('platform_family') { 'fedora' }

      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/httpd/mod_cache_disk'
      end
    end

    context 'with amazon family' do
      let('platform_family') { 'amazon' }

      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/httpd/mod_cache_disk'
      end
    end

    context 'with SUSE family' do
      let('platform_family') { 'suse' }

      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/apache2/proxy'
      end
    end

    context 'with Debian' do
      let('platform_family') { 'debian' }
      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/apache2/proxy'
      end
    end

    context 'with arch' do
      let('platform_family') { 'arch' }
      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/httpd/mod_cache_disk'
      end
    end

    context 'with freebsd' do
      let('platform_family') { 'freebsd' }
      it 'returns the correct path' do
        expect(subject.default_cache_root).to eq '/var/cache/apache24/proxy'
      end
    end
  end
end
