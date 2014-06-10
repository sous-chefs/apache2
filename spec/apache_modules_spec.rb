require 'spec_helper'


RSpec.shared_examples 'an apache2 module' do |a2module, a2conf|
  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'debian' => ['7.0', '7.4'],
    'fedora' => %w(18 20),
    'redhat' => ['5.9', '6.5'],
    'centos' => ['5.9', '6.5'],
    'freebsd' => ['9.2']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|

      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) { ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe) }

        case platform
        when 'debian', 'ubuntu'
          apache_dir = '/etc/apache2'
          apache_lib_dir = '/usr/lib/apache2'
          apache_libexec_dir = "#{apache_lib_dir}/modules"
          apache_cache_dir = '/var/cache/apache2'
          apache_conf = "#{apache_dir}/apache2.conf"
        when 'redhat', 'centos', 'scientific', 'fedora', 'suse', 'amazon', 'oracle'
          apache_dir = '/etc/httpd'
          if platform == 'fedora' && version == '18'
            # defined by node.kernel.machine to be 32-bit instance in Fauxhai
            # node.automatic['kernel']['machine'] = 'i686'
            apache_lib_dir = '/usr/lib/httpd'
          else
            apache_lib_dir = '/usr/lib64/httpd'
          end
          apache_libexec_dir = "#{apache_lib_dir}/modules"
          apache_cache_dir = '/var/cache/httpd'
          apache_conf = "#{apache_dir}/conf/httpd.conf"
        when 'freebsd'
          apache_dir = '/usr/local/etc/apache22'
          apache_lib_dir = '/usr/local/libexec/apache22'
          apache_libexec_dir = apache_lib_dir
          apache_log_dir = '/var/log'
          apache_cache_dir = '/var/run/apache22'
          apache_conf = "#{apache_dir}/httpd.conf"
          apache_perl_pkg = 'perl5'
          apache_root_group = 'wheel'
        else
          apache_dir = '/tmp/bogus'
          apache_lib_dir = '/usr/lib/apache2'
          apache_libexec_dir = "#{apache_lib_dir}/modules"
        end

        it 'includes the `apache2::default` recipe' do
          expect(chef_run).to include_recipe('apache2::default')
        end

        module_name = a2module
        module_enable = true
        module_conf = a2conf
        module_identifier = "#{module_name}_module"
        module_filename = "mod_#{module_name}.so"
        module_path = "#{apache_libexec_dir}/#{module_filename}"

        if module_conf == true
          it "creates #{apache_dir}/mods-available/#{module_name}.conf" do
            expect(chef_run).to create_template("#{apache_dir}/mods-available/#{module_name}.conf").with(
              :source => "mods/#{module_name}.conf.erb",
              :mode =>  '0644'
            )
          end

          let(:template) { chef_run.template("#{apache_dir}/mods-available/#{module_name}.conf") }
          it "notification is triggered by #{apache_dir}/mods-available/#{module_name}.conf template to reload service[apache2]" do
            expect(template).to notify('service[apache2]').to(:reload)
            expect(template).to_not notify('service[apache2]').to(:stop)
          end
        end

        if %w(redhat centos fedora arch suse freebsd).include?(platform)
          it "creates a #{apache_dir}/mods-available/#{module_name}.load" do
            expect(chef_run).to create_file("#{apache_dir}/mods-available/#{module_name}.load").with(
              :content =>  "LoadModule #{module_identifier} #{module_path}\n",
              :mode => '0644'
            )
          end
        end

        if module_enable == true
          it "runs a2enmod #{module_name}" do
            expect(chef_run).to run_execute("a2enmod #{module_name}").with(:command => "/usr/sbin/a2enmod #{module_name}")
            expect(chef_run).to_not run_execute("a2enmod #{module_name}").with(:command => "/usr/sbin/a2dismod #{module_name}")
          end
          let(:execute) { chef_run.execute("a2enmod #{module_name}") }
          it "notification is triggered by a2enmod #{module_name} to reload service[apache2]" do
            expect(execute).to notify('service[apache2]').to(:reload)
            expect(execute).to_not notify('service[apache2]').to(:stop)
          end
#         not_if do
#           ::File.symlink?("#{node['apache']['dir']}/mods-enabled/#{params[:name]}.load") &&
#           (::File.exists?("#{node['apache']['dir']}/mods-available/#{params[:name]}.conf") ? ::File.symlink?("#{node['apache']['dir']}/mods-enabled/#{params[:name]}.conf") : true)
#         end
        else
          it "runs a2dismod #{module_name}" do
            expect(chef_run).to run_execute("a2dismod #{module_name}").with(:command => "/usr/sbin/a2dismod #{module_name}")
            expect(chef_run).to_not run_execute("a2dismod #{module_name}").with(:command => "/usr/sbin/a2enmod #{module_name}")
          end
          let(:execute) { chef_run.execute("a2dismod #{module_name}") }
          it "notification is triggered by a2dismod #{module_name} to reload service[apache2]" do
            expect(execute).to notify('service[apache2]').to(:reload)
            expect(execute).to_not notify('service[apache2]').to(:stop)
          end
#         only_if { ::File.symlink?("#{node['apache']['dir']}/mods-enabled/#{params[:name]}.load") }
        end
      end
    end
  end
end

# examples at https://github.com/sethvargo/chefspec/tree/master/examples


modules_without_config = %w(auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex env logio log_config)
modules_with_config = %w(status alias deflate alias autoindex dir mime negotiation setenvif)


modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true
  end
end

modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false
  end
end
