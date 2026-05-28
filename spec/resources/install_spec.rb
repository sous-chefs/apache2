# frozen_string_literal: true

require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_install, :apache2_config
  platform 'ubuntu'

  context 'install apache2 with default properties' do
    recipe do
      apache2_install 'package'

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end
    end

    it 'has a correct Group' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')

      is_expected.to create_template('/etc/apache2/apache2.conf').with_variables(
        access_file_name: '.htaccess',
        apache_binary: '/usr/sbin/apache2',
        apache_dir: '/etc/apache2',
        apache_group: 'www-data',
        apache_user: 'www-data',
        docroot_dir: '/var/www/html',
        error_log: 'error.log',
        keep_alive: 'On',
        max_keep_alive_requests: 1000,
        keep_alive_timeout: 2,
        lock_dir: '/var/lock/apache2',
        log_dir: '/var/log/apache2',
        log_level: 'warn',
        pid_file: '/var/run/apache2/apache2.pid',
        run_dir: '/var/run/apache2',
        server_name: 'localhost',
        timeout: '60'
      )
    end
  end
  context 'install apache2 with apache2.conf from custom cookbook' do
    recipe do
      apache2_install 'custom' do
        template_cookbook 'test'
      end

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end
    end

    it 'render template properly' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')

      is_expected.to create_template('/etc/apache2/apache2.conf').with_variables(
        access_file_name: '.htaccess',
        apache_binary: '/usr/sbin/apache2',
        apache_dir: '/etc/apache2',
        apache_group: 'www-data',
        apache_user: 'www-data',
        docroot_dir: '/var/www/html',
        error_log: 'error.log',
        keep_alive: 'On',
        max_keep_alive_requests: 1000,
        keep_alive_timeout: 2,
        lock_dir: '/var/lock/apache2',
        log_dir: '/var/log/apache2',
        log_level: 'warn',
        pid_file: '/var/run/apache2/apache2.pid',
        run_dir: '/var/run/apache2',
        server_name: 'localhost',
        timeout: '60'
      )
    end

    it 'has a configuration from custom cookbook' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/apache2.conf')
        .with_content(/Use template_cookbook property in apache2_config or apache2_install to provide your own apache2.conf/)
    end
  end
  context 'install apache2 with custom envvars' do
    recipe do
      apache2_install 'custom' do
        envvars_additional_params(
          FOO: 'bar'
        )
      end

      service 'apache2' do
        service_name lazy { apache_platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end
    end

    it 'has a custom envvar set' do
      is_expected.to render_file('/etc/apache2/envvars')
        .with_content(/FOO=bar/)
    end

    it 'creates the log and cache dirs with the Debian cookbook modes' do
      is_expected.to create_directory('/var/log/apache2').with(mode: '0750')
      is_expected.to create_directory('/var/cache/apache2').with(
        mode: '0755',
        owner: 'root',
        group: 'root'
      )
    end
  end
end

describe 'apache2_install on EL' do
  step_into :apache2_install, :apache2_config
  platform 'redhat', '9'

  before do
    stub_command('/usr/sbin/apachectl -t').and_return('foo')
  end

  recipe do
    apache2_install 'package'
  end

  # The EL httpd package's /usr/lib/tmpfiles.d/httpd.conf enforces these modes at
  # boot and on every package transaction; matching them here keeps a second
  # converge idempotent instead of fighting systemd-tmpfiles.
  it 'creates the log dir matching the vendor tmpfiles mode' do
    is_expected.to create_directory('/var/log/httpd').with(mode: '0700')
  end

  it 'creates the cache dir matching the vendor tmpfiles mode and ownership' do
    is_expected.to create_directory('/var/cache/httpd').with(
      mode: '0700',
      owner: 'apache',
      group: 'apache'
    )
  end
end
