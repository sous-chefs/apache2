unified_mode true

property :apache_user, String,
         default: lazy { default_apache_user },
         description: ''

property :apache_group, String,
         default: lazy { default_apache_group },
         description: ''

property :mod_page_speed, String,
         equal_to: %w(on off),
         default: 'on',
         description: ''

property :file_cache_path, String,
         default: '/var/cache/mod_pagespeed/',
         description: ''

property :output_filters, Array,
         default: ['MOD_PAGESPEED_OUTPUT_FILTER text/html'],
         description: ''

property :inherit_vhost_config, String,
         default: 'on',
         equal_to: %w(on off),
         description: ''

property :rewrite_level, String,
         default: '',
         equal_to: ['', 'PassThrough', 'CoreFilters', 'TestingCoreFilters'],
         description: 'For full info see https://www.modpagespeed.com/doc/config_filters'

property :disable_filters, String,
         default: '',
         description: 'For full info see https://www.modpagespeed.com/doc/filters'

property :enable_filters, String,
         default: '',
         description: 'For full info see https://www.modpagespeed.com/doc/filters'

property :domain, String,
         default: '',
         description: 'For full info see https://www.modpagespeed.com/doc/domains'

property :extra_config, Hash,
         default: {},
         description: 'A hash of key value pairs for enable e.g. "ModPagespeedFileCacheSizeKb" => "102400"'

property :file_cache_inode_limit, [String, Integer],
         default: '500000',
         coerce: proc { |m| m.is_a?(Integer) ? m.to_s : m },
         description: ''

property :avoid_renaming_introspective_javascript, String,
         equal_to: %w(on off),
         default: 'on',
         description: ''

property :library, Array,
        default: [
          '105527 ltVVzzYxo0 //ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js',
          '92501 J8KF47pYOq //ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js',
          '141547 GKjMUuF4PK //ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js',
          '43 1o978_K0_L http://www.modpagespeed.com/rewrite_javascript.js',
        ],
        description: 'Array of libraries to load in the form "bytes MD5 canonical_url" we prepend ModPagespeedLibrary'

action :create do
  remote_file "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb" do
    source pagespeed_url
    mode '0644'
    action :create_if_missing
  end

  package 'mod_pagespeed' do
    source "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb"
    action :install
  end

  directory new_resource.file_cache_path do
    user new_resource.apache_user
    group new_resource.apache_group
    mode '0750'
  end

  template ::File.join(apache_dir, 'mods-available', 'pagespeed.conf') do
    source 'mods/pagespeed.conf.erb'
    cookbook 'apache2'
    variables(
      mod_page_speed: new_resource.mod_page_speed,
      file_cache_path: new_resource.file_cache_path,
      output_filters: new_resource.output_filters,
      inherit_vhost_config: new_resource.inherit_vhost_config,
      rewrite_level: new_resource.rewrite_level,
      disable_filters: new_resource.disable_filters,
      enable_filters: new_resource.enable_filters,
      domain: new_resource.domain,
      extra_config: new_resource.extra_config,
      file_cache_inode_limit: new_resource.file_cache_inode_limit,
      avoid_renaming_introspective_javascript: new_resource.avoid_renaming_introspective_javascript,
      library: new_resource.library
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
