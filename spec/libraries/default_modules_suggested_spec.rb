# FIXME: this is a stub!

require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#default_run_dir' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'systemd' do # FIXME: add sysv
      before do
        allow(subject).to receive(:[]).with('init_package').and_return('systemd')
      end

      context 'redhat' do
        let(:platform_family) { 'rhel' }

        it 'generates correct module list' do
          expect(subject.default_modules).to eq %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile authz_host authz_user autoindex deflate dir env mime negotiation setenvif log_config logio unixd systemd)
        end
      end

      context 'fedora' do
        let(:platform_family) { 'fedora' }

        it 'generates correct module list' do
          expect(subject.default_modules).to eq %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile authz_host authz_user autoindex deflate dir env mime negotiation setenvif log_config logio unixd systemd)
        end
      end

      context 'suse' do
        let(:platform_family) { 'suse' }

        it 'generates correct module list' do
          expect(subject.default_modules).to eq %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile authz_host authz_user autoindex deflate dir env mime negotiation setenvif log_config logio)
        end
      end

      context 'debian' do
        let(:platform_family) { 'debian' }

        it 'generates correct module list' do
          expect(subject.default_modules).to eq %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile authz_host authz_user autoindex deflate dir env mime negotiation setenvif)
        end
      end

      context 'arch' do
        let(:platform_family) { 'arch' }

        it 'generates correct module list' do
          expect(subject.default_modules).to eq %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile authz_host authz_user autoindex deflate dir env mime negotiation setenvif log_config logio unixd)
        end
      end
    end
  end
end
