require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_install, :apache2_config
  platform 'ubuntu'

  context 'install apache2 with default properties' do
    recipe do
      apache2_install 'package'
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
        max_keep_alive_requests: 100,
        keep_alive_timeout: 5,
        lock_dir: '/var/lock/apache2',
        log_dir: '/var/log/apache2',
        log_level: 'warn',
        pid_file: '/var/run/apache2/apache2.pid',
        run_dir: '/var/run/apache2',
        server_name: 'localhost',
        timeout: '300'
      )
    end
  end
  context 'install apache2 with apache2.conf from custom cookbook' do
    recipe do
      apache2_install 'custom' do
        template_cookbook 'test'
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
        max_keep_alive_requests: 100,
        keep_alive_timeout: 5,
        lock_dir: '/var/lock/apache2',
        log_dir: '/var/log/apache2',
        log_level: 'warn',
        pid_file: '/var/run/apache2/apache2.pid',
        run_dir: '/var/run/apache2',
        server_name: 'localhost',
        timeout: '300'
      )
    end

    it 'has a configuration from custom cookbook' do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
      is_expected.to render_file('/etc/apache2/apache2.conf')
        .with_content(/Use template_cookbook property in apache2_config or apache2_install to provide your own apache2.conf/)
    end
  end
end
