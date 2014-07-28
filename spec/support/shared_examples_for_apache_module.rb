RSpec.shared_examples 'an apache2 module' do |a2module, a2conf, platforms, a2filename = nil|

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) { ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe) }

        property = load_platform_properties(:platform => platform, :platform_version => version)

        before do
          allow(::File).to receive(:symlink?).and_return(true)
          stub_command("#{property[:apache][:binary]} -t").and_return(true)
          # @todo how can we avoid having this here? It is only needed for the specific module.
          # e.g. apache2::mod_apreq2 and apache2::mod_auth_openid
          stub_command("test -f #{property[:apache][:libexec_dir]}/mod_apreq2.so").and_return(true)
          stub_command("test -f #{property[:apache][:libexec_dir]}/mod_auth_openid.so").and_return(true)
          stub_command("test -f #{property[:apache][:dir]}/mods-available/fastcgi.conf").and_return(true)
        end

        it 'includes the `apache2::default` recipe' do
          expect(chef_run).to include_recipe('apache2::default')
        end

        module_name = a2module
        module_name = 'authz_default' if a2module.eql?('authz_core') && property[:apache][:version] != '2.4'
        module_enable = true
        module_conf = a2conf
        module_identifier = "#{module_name}_module"
        module_filename = "mod_#{module_name}.so"
        module_filename = a2filename if a2filename

        if module_conf == true
          it "creates #{property[:apache][:dir]}/mods-available/#{module_name}.conf" do
            expect(chef_run).to create_template("#{property[:apache][:dir]}/mods-available/#{module_name}.conf").with(
              :source => "mods/#{module_name}.conf.erb",
              :mode =>  '0644'
            )
          end

          let(:template) { chef_run.template("#{property[:apache][:dir]}/mods-available/#{module_name}.conf") }
          it "notification is triggered by #{property[:apache][:dir]}/mods-available/#{module_name}.conf template to reload service[apache2]" do
            expect(template).to notify('service[apache2]').to(:reload)
            expect(template).to_not notify('service[apache2]').to(:stop)
          end
        end

        if module_enable == true
          it "creates a #{property[:apache][:dir]}/mods-available/#{module_name}.load" do
            expect(chef_run).to create_file("#{property[:apache][:dir]}/mods-available/#{module_name}.load").with(
              :content =>  "LoadModule #{module_name}_module #{property[:apache][:libexec_dir]}/#{module_filename}\n",
              :mode => '0644'
            )
          end

          it "runs a2enmod #{module_name}" do
            # not_if do
            allow(::File).to receive(:symlink?).with("#{property[:apache][:dir]}/mods-enabled/#{module_name}.load").and_return(false)
            # (::File.exists?("#{property[:apache][:dir]}/mods-available/#{params[:name]}.conf") ? ::File.symlink?("#{node[:apache][:dir]}/mods-enabled/#{params[:name]}.conf") : true)
            # allow(::File).to receive(:exists?).with("#{property[:apache][:dir]}/mods-available/#{module_name}.conf").and_return(false)
            expect(chef_run).to run_execute("a2enmod #{module_name}").with(:command => "/usr/sbin/a2enmod #{module_name}")
            expect(chef_run).to_not run_execute("a2enmod #{module_name}").with(:command => "/usr/sbin/a2dismod #{module_name}")
          end

          let(:execute) { chef_run.execute("a2enmod #{module_name}") }
          it "notification is triggered by a2enmod #{module_name} to reload service[apache2]" do
            expect(execute).to notify('service[apache2]').to(:reload)
            expect(execute).to_not notify('service[apache2]').to(:stop)
          end

        else
          it "runs a2dismod #{module_name}" do
            allow(::File).to receive(:symlink?).with("#{property[:apache][:dir]}/mods-enabled/#{module_name}.load").and_return(true)
            expect(chef_run).to run_execute("a2dismod #{module_name}").with(:command => "/usr/sbin/a2dismod #{module_name}")
            expect(chef_run).to_not run_execute("a2dismod #{module_name}").with(:command => "/usr/sbin/a2enmod #{module_name}")
          end
          let(:execute) { chef_run.execute("a2dismod #{module_name}") }
          it "notification is triggered by a2dismod #{module_name} to reload service[apache2]" do
            expect(execute).to notify('service[apache2]').to(:reload)
            expect(execute).to_not notify('service[apache2]').to(:stop)
          end
        end
      end
    end
  end
end
