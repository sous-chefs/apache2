require 'spec_helper'
require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../../libraries/helpers'

describe "#lib_dir_for_machine" do
  context 'x86_64' do
    automatic_attributes["kernel"]["machine"] = "x86_64"

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

    context 'suse' do
      platform 'suse'
      it { is_expected.to write_log("/usr/lib64") }
    end

    context 'freebsd' do
      platform 'freebsd'
      it { is_expected.to write_log("/usr/local") }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log("/usr/lib") }
    end
  end

  context 'x86'do
    automatic_attributes["kernel"]["machine"] = "i686"

    recipe do
      log lib_dir_for_machine
    end

    context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log("/usr/lib") }
    end
  end
end
