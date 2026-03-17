# frozen_string_literal: true

require 'spec_helper'

describe 'apache2_site' do
  step_into :apache2_site
  platform 'ubuntu'

  context 'action :enable' do
    before do
      allow_any_instance_of(Chef::Resource).to receive(:apache_site_enabled?).and_return(false)
      allow_any_instance_of(Chef::Resource).to receive(:apache_site_available?).and_return(true)
    end

    recipe do
      apache2_site 'mysite'
    end

    it { is_expected.to run_execute('a2ensite mysite') }
  end

  context 'action :disable' do
    before do
      allow_any_instance_of(Chef::Resource).to receive(:apache_site_enabled?).and_return(true)
    end

    recipe do
      apache2_site 'mysite' do
        action :disable
      end
    end

    it { is_expected.to run_execute('a2dissite mysite') }
  end
end
