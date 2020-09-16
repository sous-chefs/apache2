require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#default_pass_phrase_dialog' do
    before do
      allow(subject).to receive(:[]).with(:platform).and_return(platform)
    end

    context 'with rhel family' do
      let(:platform) { 'rhel' }

      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end

    context 'with fedora family' do
      let(:platform) { 'fedora' }

      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end

    context 'with amazon family' do
      let(:platform) { 'amazon' }

      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end

    context 'with SUSE family' do
      let(:platform) { 'suse' }

      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end

    context 'with Debian' do
      let(:platform) { 'debian' }
      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end

    context 'with Ubuntu' do
      let(:platform) { 'ubuntu' }
      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'exec:/usr/share/apache2/ask-for-passphrase'
      end
    end

    context 'with arch' do
      let(:platform) { 'arch' }
      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end

    context 'with freebsd' do
      let(:platform) { 'freebsd' }
      it 'returns the correct path' do
        expect(subject.default_pass_phrase_dialog).to eq 'builtin'
      end
    end
  end
end
