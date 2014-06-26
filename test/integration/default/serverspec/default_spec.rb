require_relative '../../../kitchen/data/spec_helper'

describe 'apache2::default' do

  describe package('apache2') do
    it { should be_installed }
  end

  describe service('apache2') do
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

  describe file("#{node['apache']['dir']}/conf.d") do
    it { should be_directory }
    it { should be_mode 775 }
  end

  describe file(node['apache']['log_dir']) do
    it { should be_directory }
    it { should be_mode 775 }
  end
end
