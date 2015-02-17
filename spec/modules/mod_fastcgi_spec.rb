require 'spec_helper'

describe 'apache2::mod_fastcgi' do
  shared_examples 'rhel installs compilation tools' do
    it 'installs compilation tools' do
      %w(gcc make libtool httpd-devel apr-devel apr).each do |package|
        expect(chef_run).to upgrade_yum_package(package)
      end
    end
  end
  shared_examples 'debian installs compilation tools' do
    it 'installs compilation tools' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('apache2-dev')
    end
  end
  shared_examples "debian doesn't install compilation tools" do
    it "doesn't install compilation tools" do
      expect(chef_run).to_not install_package('build-essential')
    end
  end
  shared_examples 'compiles mod_fastcgi from source' do
    it 'compiles mod_fastcgi from source' do
      expect(chef_run).to run_bash('compile fastcgi source')
    end
  end
  shared_examples "doesn't compile mod_fastcgi from source" do
    it "doesn't compile mod_fastcgi from source" do
      expect(chef_run).to_not run_bash('compile fastcgi source')
    end
  end

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          @chef_run
        end

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before(:context) do
          @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version)
          stub_command("test -f #{property[:apache][:dir]}/mods-available/fastcgi.conf").and_return(false)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          @chef_run.converge(described_recipe)
        end

        if %w(debian ubuntu).include?(platform)
          it 'installs package libapache2-mod-fastcgi' do
            expect(chef_run).to install_package('libapache2-mod-fastcgi')
          end
          it_should_behave_like "debian doesn't install compilation tools"
          it_should_behave_like "doesn't compile mod_fastcgi from source"
        elsif %w(redhat centos).include?(platform)
          it_should_behave_like 'rhel installs compilation tools'
          it_should_behave_like 'compiles mod_fastcgi from source'
        end
        it_should_behave_like 'an apache2 module', 'fastcgi', true

        context 'we force to use mod_fastcgi source' do
          let(:chef_run) do
            @chef_run
          end

          property = load_platform_properties(:platform => platform, :platform_version => version)

          before(:context) do
            @chef_run = ChefSpec::SoloRunner.new(:platform => platform, :version => version) do |node|
              node.set['apache']['mod_fastcgi']['install_method'] = 'source'
            end
            stub_command("test -f #{property[:apache][:dir]}/mods-available/fastcgi.conf").and_return(false)
            stub_command("#{property[:apache][:binary]} -t").and_return(true)
            @chef_run.converge(described_recipe)
          end

          if %w(debian ubuntu).include?(platform)
            it_should_behave_like 'debian installs compilation tools'
            it_should_behave_like 'compiles mod_fastcgi from source'
          elsif %w(redhat centos).include?(platform)
            it_should_behave_like 'rhel installs compilation tools'
            it_should_behave_like 'compiles mod_fastcgi from source'
          end
        end
      end
    end
  end
end
