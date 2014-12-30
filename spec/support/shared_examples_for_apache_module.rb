RSpec.shared_examples 'an apache2 module' do |a2module, a2conf, a2filename = nil, a2restart = false|
  before do
    allow(::File).to receive(:symlink?).and_return(true)
  end

  it 'includes the `apache2::default` recipe' do
    expect(chef_run).to include_recipe('apache2::default')
  end

  module_name = a2module
  module_enable = true
  module_conf = a2conf
  module_identifier = "#{module_name}_module"
  module_filename = "mod_#{module_name}.so"
  module_filename = a2filename if a2filename

  service_restart = a2restart

  if module_conf == true
    it "creates <apache_dir>/mods-available/#{module_name}.conf" do
      expect(chef_run).to create_template("#{chef_run.node[:apache][:dir]}/mods-available/#{module_name}.conf").with(
        :source => "mods/#{module_name}.conf.erb",
        :mode =>  '0644'
      )
    end

    let(:template) { chef_run.template("#{chef_run.node[:apache][:dir]}/mods-available/#{module_name}.conf") }
    it "notification is triggered by <apache_dir>/mods-available/#{module_name}.conf template to reload/restart service[apache2]" do
      expect(template).to notify('service[apache2]').to(:reload)
      expect(template).to_not notify('service[apache2]').to(:stop)
    end
  end

  if module_enable == true
    it "creates <apache_dir>/mods-available/#{module_name}.load" do
      expect(chef_run).to create_file("#{chef_run.node[:apache][:dir]}/mods-available/#{module_name}.load").with(
        :content =>  "LoadModule #{module_name}_module #{chef_run.node[:apache][:libexec_dir]}/#{module_filename}\n",
        :mode => '0644'
      )
    end

    it "runs a2enmod #{module_name}" do
      # not_if do
      allow(::File).to receive(:symlink?).with("#{chef_run.node[:apache][:dir]}/mods-enabled/#{module_name}.load").and_return(false)
      # (::File.exists?("#{chef_run.node[:apache][:dir]}/mods-available/#{params[:name]}.conf") ? ::File.symlink?("#{node[:apache][:dir]}/mods-enabled/#{params[:name]}.conf") : true)
      # allow(::File).to receive(:exists?).with("#{chef_run.node[:apache][:dir]}/mods-available/#{module_name}.conf").and_return(false)
      expect(chef_run).to run_execute("a2enmod #{module_name}").with(:command => "/usr/sbin/a2enmod #{module_name}")
      expect(chef_run).to_not run_execute("a2enmod #{module_name}").with(:command => "/usr/sbin/a2dismod #{module_name}")
    end

    let(:execute) { chef_run.execute("a2enmod #{module_name}") }
    it "notification is triggered by a2enmod #{module_name} to reload/restart service[apache2]" do
      if service_restart == true
        expect(execute).to notify('service[apache2]').to(:restart)
      else
        expect(execute).to notify('service[apache2]').to(:reload)
      end
      expect(execute).to_not notify('service[apache2]').to(:stop)
    end

  else
    it "runs a2dismod #{module_name}" do
      allow(::File).to receive(:symlink?).with("#{chef_run.node[:apache][:dir]}/mods-enabled/#{module_name}.load").and_return(true)
      expect(chef_run).to run_execute("a2dismod #{module_name}").with(:command => "/usr/sbin/a2dismod #{module_name}")
      expect(chef_run).to_not run_execute("a2dismod #{module_name}").with(:command => "/usr/sbin/a2enmod #{module_name}")
    end
    let(:execute) { chef_run.execute("a2dismod #{module_name}") }
    it "notification is triggered by a2dismod #{module_name} to reload/restart service[apache2]" do
      if service_restart == true
        expect(execute).to notify('service[apache2]').to(:restart)
      else
        expect(execute).to notify('service[apache2]').to(:reload)
      end
      expect(execute).to_not notify('service[apache2]').to(:stop)
    end
  end
end
