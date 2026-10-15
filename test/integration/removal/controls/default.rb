# frozen_string_literal: true

control 'apache2-removal' do
  impact 1.0
  desc 'Server package, configuration, logs and management scripts are removed'

  apache_package = %w(debian suse).include?(os.family) ? 'apache2' : 'httpd'
  apache_dir = %w(debian suse).include?(os.family) ? '/etc/apache2' : '/etc/httpd'

  describe file('/var/tmp/apache2-removal-seeded') do
    it { should exist }
  end

  describe package(apache_package) do
    it { should_not be_installed }
  end

  [apache_dir, "/var/log/#{apache_package}", '/usr/sbin/a2enmod',
   '/usr/sbin/a2ensite', '/usr/sbin/a2dissite', '/usr/sbin/a2dismod',
   '/usr/sbin/a2enconf', '/usr/sbin/a2disconf',
   '/usr/local/bin/apache2_module_conf_generate.pl'].each do |path|
    describe file(path) do
      it { should_not exist }
    end
  end

  describe systemd_service(apache_package) do
    it { should_not be_running }
    it { should_not be_enabled }
  end
end
