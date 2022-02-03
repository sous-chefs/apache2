unified_mode true

property :name, String, default: ''

property :install_method, String,
         equal_to: %w( source package ),
         default: lazy { apache_mod_auth_cas_install_method },
         description: 'Install method for Mod auth CAS'

property :source_revision, String,
         default: 'v1.2',
         description: 'Revision for the mod auth cas source install'

property :source_checksum, String,
         default: 'b05a194f6c255f65a10537242648d8c0c2110960c03aff240bd8f52eaa454c29',
         description: 'Checksum for the mod auth cas source install'

property :login_url, String,
         default: 'https://login.example.org/cas/login',
         description: 'The URL to redirect users to when they attempt to access a CAS protected resource and do not have an existing session.'

property :validate_url, String,
         default: 'https://login.example.org/cas/serviceValidate',
         description: 'The URL to use when validating a ticket presented by a client'

property :root_group, String,
         default: lazy { node['root_group'] },
         description: 'Group that the root user on the box runs as.
Defaults to platform specific locations, see libraries/helpers.rb'

property :apache_user, String,
         default: lazy { default_apache_user },
         description: 'Set to override the default apache2 user.
Defaults to platform specific locations, see libraries/helpers.rb'

property :apache_group, String,
         default: lazy { default_apache_group },
         description: 'Set to override the default apache2 user.
Defaults to platform specific locations, see libraries/helpers.rb'

property :mpm, String,
         default: lazy { default_mpm },
         description: 'Apache2 MPM: used to determine which devel package to install on Debian'

property :directives, Hash,
        description: 'Hash of optional directives to pass to the mod_auth_cas module configuration'

action :install do
  if new_resource.install_method.eql? 'source'
    package [apache_devel_package(new_resource.mpm), apache_mod_auth_cas_devel_packages].flatten

    build_essential 'mod_auth_cas'

    mod_auth_cas_tarball = "#{Chef::Config[:file_cache_path]}/mod_auth_cas.tar.gz"

    remote_file mod_auth_cas_tarball do
      source "https://github.com/apereo/mod_auth_cas/archive/#{new_resource.source_revision}.tar.gz"
      checksum new_resource.source_checksum
    end

    archive_file mod_auth_cas_tarball do
      destination "#{Chef::Config[:file_cache_path]}/mod_auth_cas"
      notifies :run, 'execute[compile mod_auth_cas]', :immediately
    end

    execute 'compile mod_auth_cas' do
      command 'autoreconf -ivf && ./configure && make && make install'
      cwd "#{Chef::Config[:file_cache_path]}/mod_auth_cas/mod_auth_cas-#{new_resource.source_revision.gsub(/^v/, '')}"
      not_if { ::File.exist?("#{apache_libexec_dir}/mod_auth_cas.so") }
    end

    template "#{apache_dir}/mods-available/auth_cas.load" do
      cookbook 'apache2'
      source 'mods/auth_cas.load.erb'
      owner 'root'
      group new_resource.root_group
      variables(cache_dir: cache_dir, libexec_dir: apache_libexec_dir)
      mode '0644'
    end
  else

    case node['platform_family']
    when 'debian'
      package 'libapache2-mod-auth-cas'
    when 'rhel', 'fedora', 'amazon'
      include_recipe 'yum-epel' unless platform_family?('fedora')

      package 'mod_auth_cas' do
        notifies :run, 'execute[generate-module-list]', :immediately
        notifies :delete, 'directory[purge distro conf.modules.d]', :immediately
        notifies :delete, 'directory[purge distro conf.d]', :immediately
      end

      directory 'purge distro conf.modules.d' do
        path "#{apache_dir}/conf.modules.d"
        recursive true
        action :nothing
      end

      directory 'purge distro conf.d' do
        path "#{apache_dir}/conf.d"
        recursive true
        action :nothing
      end

      file "#{apache_dir}/conf.d/auth_cas.conf" do
        content '# conf is under mods-available/auth_cas.conf - apache2 cookbook\n'
        only_if { ::Dir.exist?("#{apache_dir}/conf.d") }
      end
    end
  end

  apache2_module 'auth_cas' do
    template_cookbook 'apache2'
    mod_conf(
      cache_dir: cache_dir,
      login_url: new_resource.login_url,
      validate_url: new_resource.validate_url,
      directives: new_resource.directives
    )
    notifies :reload, 'service[apache2]', :delayed
  end

  directory "#{cache_dir}/mod_auth_cas" do
    owner new_resource.apache_user
    group new_resource.apache_group
    mode '0700'
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
