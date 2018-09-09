require 'spec_helper'
require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../../libraries/helpers'

describe "#lib_dir_for_machine" do
  context 'x86_64' do
    automatic_attributes["kernel"]["machine"] = "x86_64"

    context 'redhat' do
      recipe do
        log lib_dir_for_machine
      end

      platform 'redhat'
      it { is_expected.to write_log("/usr/lib64") }
    end

    context 'arch' do
      recipe do
        log lib_dir_for_machine
      end

      platform 'arch'
      it { is_expected.to write_log("/usr/lib") }
    end

    context 'freebsd' do
      recipe do
        log lib_dir_for_machine
      end

      platform 'freebsd'
      it { is_expected.to write_log("/usr/local") }
    end
  end

  context 'x86'do
    automatic_attributes["kernel"]["machine"] = "i686"

    context 'redhat' do
      recipe do
        log lib_dir_for_machine
      end

      platform 'redhat'
      it { is_expected.to write_log("/usr/lib") }
    end
  end
end
