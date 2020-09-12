unified_mode true

property :public_html_dir, String,
         default: '/home/*/public_html',
         description: ''

property :options, String,
         default: 'MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec',
         description: ''

property :allow_override, String,
         default: 'FileInfo AuthConfig Limit Indexes',
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/core.html#allowoverride'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'userdir.conf') do
    source 'mods/userdir.conf.erb'
    cookbook 'apache2'
    variables(
      public_html_dir: new_resource.public_html_dir,
      allow_override: new_resource.allow_override,
      options: new_resource.options
    )
  end
end
