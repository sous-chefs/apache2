require 'spec_helper'

RSpec.describe Apache2::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Apache2::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#has_config_file?' do
    before do
      allow(subject).to receive(:[]).with('mod_name').and_return(mod_name)
    end

    context 'mod_auth_basic' do
      let(:mod_name) { 'ldap' }

      it 'returns the correct path' do
        expect(subject.has_config_file?(mod_name)).to be_truthy
      end
    end
  end
end
