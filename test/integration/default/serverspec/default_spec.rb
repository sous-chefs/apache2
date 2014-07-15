require_relative '../../../kitchen/data/spec_helper'

describe 'apache2::default' do

  pkg = 'httpd'
  describe package(pkg) do
    it { should be_installed }
  end

  describe service(pkg) do
    it { should be_enabled   }
    it { should be_running   }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file('/etc/httpd/conf/httpd.conf') do
    it { should be_file }
    # its(:content) { should match /ServerName www.example.jp/ }
  end

  # describe file("#{node['apache']['dir']}/conf.d") do
  describe file('/etc/httpd/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
  end

  # describe file(node['apache']['log_dir']) do
  describe file('/var/log/httpd') do
    it { should be_directory }
    it { should be_mode 755 }
  end
end
