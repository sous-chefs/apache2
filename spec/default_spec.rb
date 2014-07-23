require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'apache2::default' do
  before do
    allow(::File).to receive(:symlink?).and_return(false)
  end

  # Test all defaults on all platforms
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version) do
          end.converge(described_recipe)
        end
        property = load_platform_properties(:platform => platform, :platform_version => version)
        it "installs package #{property[:apache][:package]}" do
          expect(chef_run).to install_package(property[:apache][:package])
        end

        if %w(redhat centos fedora arch suse freebsd).include?(platform)
          it "creates #{property[:apache][:log_dir]} directory" do
            expect(chef_run).to create_directory(property[:apache][:log_dir]).with(
              :mode => '0755'
            )

            expect(chef_run).to_not create_directory(property[:apache][:log_dir]).with(
              :mode => '0777'
            )
          end

          it "installs package #{property[:apache][:perl_pkg]}" do
            expect(chef_run).to install_package(property[:apache][:perl_pkg])
          end

          it 'creates /usr/local/bin/apache2_module_conf_generate.pl' do
            expect(chef_run).to create_cookbook_file('/usr/local/bin/apache2_module_conf_generate.pl').with(
              :mode =>  '0755',
              :owner => 'root',
              :group => property[:apache][:root_group]
            )
            expect(chef_run).to_not create_cookbook_file('/usr/bin/apache2_module_conf_generate.pl')
          end

          it 'runs a execute[generate-module-list] with :nothing action' do
            # .with(
            #  command: "/usr/local/bin/apache2_module_conf_generate.pl #{apache_lib_dir} #{property[:apache][:dir]}/mods-available"
            # )
            execute = chef_run.execute('generate-module-list')
            expect(execute).to do_nothing
          end

          %w(sites-available sites-enabled mods-available mods-enabled).each do |dir|
            it "creates #{property[:apache][:dir]}/#{dir} directory" do
              expect(chef_run).to create_directory("#{property[:apache][:dir]}/#{dir}").with(
                :mode => '0755',
                :owner => 'root',
                :group => property[:apache][:root_group]
              )

              expect(chef_run).to_not create_directory("#{property[:apache][:dir]}/#{dir}").with(
                :mode => '0777'
              )
            end
          end

          %w(a2ensite a2dissite a2enmod a2dismod).each do |modscript|
            it "creates /usr/sbin/#{modscript}" do
              expect(chef_run).to create_template("/usr/sbin/#{modscript}")
            end
          end

          %w(proxy_ajp auth_pam authz_ldap webalizer ssl welcome).each do |f|
            it "deletes #{property[:apache][:dir]}/conf.d/#{f}.conf" do
              expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/#{f}.conf").with(:backup => false)
              expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/#{f}.conf").with(:backup => true)
            end
          end

          it "deletes #{property[:apache][:dir]}/conf.d/README" do
            expect(chef_run).to delete_file("#{property[:apache][:dir]}/conf.d/README").with(:backup => false)
            expect(chef_run).to_not delete_file("#{property[:apache][:dir]}/conf.d/README").with(:backup => true)
          end

          it 'includes the `apache2::mod_deflate` recipe' do
            expect(chef_run).to include_recipe('apache2::mod_deflate')
          end
        end

        it "creates #{property[:apache][:conf]}" do
          expect(chef_run).to create_template(property[:apache][:conf]).with(
            :source => 'apache2.conf.erb',
            :owner => 'root',
            :group => property[:apache][:root_group],
            :mode =>  '0644'
          )
        end

        let(:apacheconf) { chef_run.template(property[:apache][:conf]) }
        it "notification is triggered by #{property[:apache][:conf]} template to reload service[apache2]" do
          expect(apacheconf).to notify('service[apache2]').to(:reload).delayed
          expect(apacheconf).to_not notify('service[apache2]').to(:reload).immediately
        end

        %w(security charset).each do |config|
          it "creates #{property[:apache][:dir]}/conf-available/#{config}.conf" do
            expect(chef_run).to create_template("#{property[:apache][:dir]}/conf-available/#{config}.conf").with(
              :source => "#{config}.conf.erb",
              :owner => 'root',
              :group => property[:apache][:root_group],
              :mode =>  '0644',
              :backup =>  false
            )
          end

          let(:confd) { chef_run.template("#{property[:apache][:dir]}/conf-available/#{config}.conf") }
          it "notification is triggered by #{property[:apache][:dir]}/conf-available/#{config}.conf template to reload service[apache2]" do
            expect(confd).to notify('service[apache2]').to(:reload).delayed
            expect(confd).to_not notify('service[apache2]').to(:reload).immediately
          end
        end

        it "creates #{property[:apache][:dir]}/ports.conf" do
          expect(chef_run).to create_template("#{property[:apache][:dir]}/ports.conf").with(
            :source => 'ports.conf.erb',
            :owner => 'root',
            :group => property[:apache][:root_group],
            :mode =>  '0644'
          )
        end

        let(:portsconf) { chef_run.template("#{property[:apache][:dir]}/ports.conf") }
        it "notification is triggered by #{property[:apache][:dir]}/ports.conf template to reload service[apache2]" do
          expect(portsconf).to notify('service[apache2]').to(:reload).delayed
          expect(portsconf).to_not notify('service[apache2]').to(:reload).immediately
        end

        it "creates #{property[:apache][:dir]}/sites-available/default.conf" do
          expect(chef_run).to create_template("#{property[:apache][:dir]}/sites-available/default.conf").with(
            :source => 'default-site.conf.erb',
            :owner => 'root',
            :group => property[:apache][:root_group],
            :mode =>  '0644'
          )
        end

        let(:defaulttemplate) { chef_run.template("#{property[:apache][:dir]}/sites-available/default.conf") }
        it "notification is triggered by #{property[:apache][:dir]}/sites-available/default.conf template to reload service[apache2]" do
          expect(defaulttemplate).to notify('service[apache2]').to(:reload).delayed
          expect(defaulttemplate).to_not notify('service[apache2]').to(:reload).immediately
        end

        if %w(redhat centos fedora).include?(platform)
          it 'creates /etc/sysconfig/httpd' do
            expect(chef_run).to create_template('/etc/sysconfig/httpd').with(
              :source => 'etc-sysconfig-httpd.erb',
              :owner => 'root',
              :group => property[:apache][:root_group],
              :mode =>  '0644'
            )
          end
        end

        if platform == 'freebsd'
          it "deletes #{property[:apache][:dir]}/Includes" do
            expect(chef_run).to delete_directory("#{property[:apache][:dir]}/Includes")
          end

          it "deletes #{property[:apache][:dir]}/extra" do
            expect(chef_run).to delete_directory("#{property[:apache][:dir]}/extra")
          end
        end
        %W(
          #{property[:apache][:dir]}/ssl
          #{property[:apache][:cache_dir]}
        ).each do |path|
          it "creates #{path} directory" do
            expect(chef_run).to create_directory(path).with(
              :mode => '0755',
              :owner => 'root',
              :group => property[:apache][:root_group]
            )
          end
        end

        property[:apache][:default_modules].each do |mod|
          module_recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
          it "includes the `apache2::#{module_recipe_name}` recipe" do
            expect(chef_run).to include_recipe("apache2::#{module_recipe_name}")
          end
        end

        it "runs a a2dissite #{property[:apache][:default_site_name]}" do
          allow(::File).to receive(:symlink?).with("#{property[:apache][:dir]}/sites-enabled/default").and_return(true)
          allow(::File).to receive(:symlink?).with("#{property[:apache][:dir]}/sites-enabled/000-default").and_return(true)
          expect(chef_run).to run_execute("a2dissite #{property[:apache][:default_site_name]}").with(
             :command => "/usr/sbin/a2dissite #{property[:apache][:default_site_name]}"
          )
        end
        it 'does not run a a2dissite default' do
          allow(::File).to receive(:symlink?).with("#{property[:apache][:dir]}/sites-enabled/default").and_return(false)
          allow(::File).to receive(:symlink?).with("#{property[:apache][:dir]}/sites-enabled/000-default").and_return(false)
          expect(chef_run).to_not run_execute("a2dissite #{property[:apache][:default_site_name]}").with(
             :command => "/usr/sbin/a2dissite #{property[:apache][:default_site_name]}"
          )
        end

        let(:execute) { chef_run.execute("a2dissite #{property[:apache][:default_site_name]}") }
        it "notification is triggered by a2dissite #{property[:apache][:default_site_name]} to reload service[apache2]" do
          expect(execute).to notify('service[apache2]').to(:reload)
          expect(execute).to_not notify('service[apache2]').to(:stop)
        end

        it 'enables an apache2 service' do
          expect(chef_run).to enable_service('apache2').with(
            :service_name => property[:apache][:service_name],
            :restart_command => property[:apache][:service_restart_command],
            :reload_command => property[:apache][:service_reload_command],
            :supports => { :start => true, :restart => true, :reload => true, :status => true },
            :action => [:enable, :start]
          )
        end

      end
    end
  end
end
