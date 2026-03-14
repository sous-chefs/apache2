# frozen_string_literal: true

require 'spec_helper'

describe 'apache2_service' do
  step_into :apache2_service
  platform 'ubuntu'

  context 'with default properties' do
    recipe do
      apache2_service 'default' do
        action :start
      end
    end

    it { is_expected.to start_service('apache2') }
  end

  context 'action :stop' do
    recipe do
      apache2_service 'default' do
        action :stop
      end
    end

    it { is_expected.to stop_service('apache2') }
  end

  context 'action :restart' do
    recipe do
      apache2_service 'default' do
        delay_start false
        action :restart
      end
    end

    it { is_expected.to restart_service('apache2') }
  end

  context 'action :reload' do
    recipe do
      apache2_service 'default' do
        delay_start false
        action :reload
      end
    end

    it { is_expected.to reload_service('apache2') }
  end

  context 'action :enable' do
    recipe do
      apache2_service 'default' do
        action :enable
      end
    end

    it { is_expected.to enable_service('apache2') }
  end

  context 'action :disable' do
    recipe do
      apache2_service 'default' do
        action :disable
      end
    end

    it { is_expected.to disable_service('apache2') }
  end

  context 'with custom service_name' do
    recipe do
      apache2_service 'default' do
        service_name 'httpd'
        action :start
      end
    end

    it { is_expected.to start_service('apache2').with(service_name: 'httpd') }
  end

  context 'on rhel platform' do
    platform 'centos', '8'

    recipe do
      apache2_service 'default' do
        action :start
      end
    end

    it { is_expected.to start_service('apache2') }
  end
end
