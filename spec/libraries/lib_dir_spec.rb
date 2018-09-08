require 'spec_helper'
require 'chefspec'
require_relative '../../libraries/helpers'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#lib_dir_for_machine' do
    before do
      allow(subject).to receive(:[]).and_return({kernel: {machine: 'x64'} } )

      # allow(myobject).to receive(:node).and_return({kernel: {machine: ‘fake’}, other: ‘attribute’})

    end

    context 'with a 64 bit machine' do
      # let(:kernel) { machine: 's390x' }
      # let(:platform_family) { 'rhel' }

      it 'returns the correct directory' do
        expect(subject.lib_dir_for_machine).to eq '/usr/lib64'
      end
    end
  end
end

  # describe '#lib_dir' do
  #   before do
  #     allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
  #     allow(subject).to receive(:[]).with('kernel').and_return(kernel: {machine: 's390x'})
  #
  #     # allow(subject).to receive(:[]).and_return(
  #     #   platform_family
  #       # kernel: {machine: 'fake'}
  #     # )
  #   end
  #
  #   context 'with rhel family' do
  #     let(:platform_family) { 'rhel' }
  #
  #     it 'returns the correct directory' do
  #       expect(subject.lib_dir).to eq '/usr/lib64/httpd'
  #     end
  #   end
  #
  #   context 'with amazon family' do
  #     let(:platform_family) { 'amazon' }
  #
  #     it 'returns the correct directory' do
  #       expect(subject.lib_dir).to eq '/usr/lib64/httpd'
  #     end
  #   end
  #
  #   context 'with SUSE family' do
  #     let(:platform_family) { 'suse' }
  #
  #     it 'returns the correct directory' do
  #       expect(subject.lib_dir).to eq '/usr/lib64/apache2'
  #     end
  #   end
  #
  #   context 'with Debian family' do
  #     let(:platform_family) { 'debian' }
  #
  #     it 'returns the correct directory' do
  #       expect(subject.lib_dir).to eq '/usr/lib/apache2'
  #     end
  #   end
  #
  #   context 'with Arch family' do
  #     let(:platform_family) { 'arch' }
  #
  #     it 'returns the correct directory' do
  #       expect(subject.lib_dir).to eq '/usr/lib/httpd'
  #     end
  #   end
  #
  #   context 'with FreeBSD family' do
  #     let(:platform_family) { 'frebsd' }
  #
  #     it 'returns the correct directory' do
  #       expect(subject.lib_dir).to eq '/usr/local/libexec/apache24'
  #     end
  #   end
  #
  #   context 'with unknown platform' do
  #     let(:platform_family) { 'foobar' }
  #
  #     it 'returns the default directory' do
  #       expect(subject.lib_dir).to eq '/usr/lib/apache2'
  #     end
  #   end
#   end
# end
