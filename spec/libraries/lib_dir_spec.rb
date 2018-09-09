require 'spec_helper'
require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../../libraries/helpers'

RSpec.describe Apache2::Cookbook::Helpers do
  describe "#lib_dir_for_machine" do
    context 'x86_64' do
      recipe do
        log lib_dir_for_machine
      end

      context 'redhat' do
        platform 'redhat'
        it { is_expected.to write_log("/usr/lib64") }
      end

      context 'arch' do
        platform 'arch'
        it { is_expected.to write_log("/usr/lib") }
      end

      context 'freebsd' do
        platform 'freebsd'
        it { is_expected.to write_log("/usr/local") }
      end
    end
  end
end
