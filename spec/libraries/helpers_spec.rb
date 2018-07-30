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
      it 'returns the corect path' do
        expect(subject.apache_binary).to eq '/usr/sbin/apache2'
      end
    end

    context 'with arch' do
      let(:platform_family) { 'arch' }
      it 'returns the corect path' do
        expect(subject.apache_binary).to eq '/usr/sbin/httpd'
      end
    end

    context 'with freebsd' do
      let(:platform_family) { 'freebsd' }
      it 'returns the corect path' do
        expect(subject.apache_binary).to eq '/usr/local/sbin/httpd'
      end
    end
  end
end
