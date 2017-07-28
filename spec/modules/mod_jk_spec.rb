require 'spec_helper'

describe 'apache2::mod_jk' do
  shared_examples 'installs compilation tools' do |devel_package|
    it 'installs compilation tools' do
      package = %W(gcc gcc-c++ #{devel_package} apr apr-devel apr-util apr-util-devel make autoconf libtool)
      expect(chef_run).to install_package(package)
    end
  end
  shared_examples "doesn't installs compilation tools" do |devel_package|
    it "doesn't installs compilation tools" do
      package = %W(gcc gcc-c++ #{devel_package} apr apr-devel apr-util apr-util-devel make autoconf libtool)
      expect(chef_run).to_not install_package(package)
    end
  end
  shared_examples 'installs mod_jk from source' do
    it 'untar mod_jk' do
      expect(chef_run).to run_bash('untar mod_jk')
    end
    it 'compile mod_jk' do
      expect(chef_run).to run_bash('compile mod_jk')
    end
    it 'install mod_jk' do
      expect(chef_run).to run_bash('install mod_jk')
    end
  end
  shared_examples "doesn't compile mod_jk from source" do
    it "doesn't compile mod_jk from source" do
      expect(chef_run).to_not run_bash('untar mod_jk')
      expect(chef_run).to_not run_bash('compile mod_jk')
      expect(chef_run).to_not run_bash('install mod_jk')
    end
  end
  shared_examples 'installs mod_jk from package' do
    it 'installs package' do
      expect(chef_run).to install_package('libapache2-mod-jk')
    end
  end

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(platform: platform, platform_version: version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(platform: platform, version: version)
          stub_command("test -f #{Chef::Config['file_cache_path']}/tomcat-connectors-1.2.42-src/native/apache-2.0/.libs/mod_jk.so").and_return(false)
          stub_command("test -f #{property[:apache][:libexec_dir]}/mod_jk.so").and_return(false)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        if %w(redhat centos amazon fedora).include?(platform)
          it_should_behave_like "installs compilation tools", property[:apache][:devel_package]
          it_should_behave_like "installs mod_jk from source"
        else
          it_should_behave_like "doesn't installs compilation tools", property[:apache][:devel_package]
          it_should_behave_like "doesn't compile mod_jk from source"
          it_should_behave_like "installs mod_jk from package"
        end

        it_should_behave_like 'an apache2 module', 'jk', false
      end
    end
  end
end
