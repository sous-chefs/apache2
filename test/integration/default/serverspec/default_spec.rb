require_relative '../../../kitchen/data/spec_helper'

describe 'apache2::default' do

  describe package(property[:apache][:package]) do
    it { should be_installed }
  end

  describe service(property[:apache][:service_name]) do
    it { should be_enabled   }
    it { should be_running   }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file(property[:apache][:conf]) do
    it { should be_file }
    # its(:content) { should match /ServerName www.example.jp/ }
  end

  describe file(property[:apache][:dir]) do
    it { should be_directory }
    it { should be_mode 755 }
  end

  %w(conf.d conf-enabled conf-available sites-enabled sites-available mods-enabled mods-available).each do |dir|
    describe file("#{property[:apache][:dir]}/#{dir}") do
      it { should be_directory }
      it { should be_mode 755 }
    end
  end

  describe file(property[:apache][:log_dir]) do
    it { should be_directory }
    it { should be_mode 755 }
  end

  describe file(property[:apache][:lib_dir]) do
    it { should be_directory }
    it { should be_mode 755 }
  end

  describe file(property[:apache][:docroot_dir]) do
    it { should be_directory }
    it { should be_mode 755 }
  end

  describe file(property[:apache][:cgibin_dir]) do
    it { should be_directory }
    it { should be_mode 755 }
  end
end
