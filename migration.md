# Migrating to the resource-only Apache cookbook

## Breaking changes

* `apache2_mod_pagespeed` has been removed. Apache retired its PageSpeed project;
  this cookbook no longer downloads the old Google packages or supplies its template.
  Remove declarations of that resource and any `apache2_module 'pagespeed'` usage
  that depends on the cookbook template before upgrading. Existing installations
  are not automatically uninstalled by a cookbook upgrade.
* openSUSE Leap 15 is EOL; use Leap 16. Fedora must be a supported release (43+).
* Service lifecycle actions use `systemd_unit` with the distribution-provided unit.
  Notify `apache2_service[default]`, as shown below, rather than a nested resource.
* Resource documentation now lives at `documentation/apache2_<resource>.md`.

## Recipes and attributes become resource declarations

The cookbook has no public `recipes/` or `attributes/` directories. Replace legacy
recipe inclusion and node configuration with resource properties in your wrapper
cookbook. The resource-only API was already present in apache2 10.1; these examples
also help consumers migrating from older recipe-based versions.

```ruby
apache2_install 'default' do
  listen ['8080']
  server_name 'www.example.org'
  mpm 'event'
  notifies :restart, 'apache2_service[default]', :delayed
end

apache2_module 'proxy'
apache2_module 'proxy_http'

apache2_default_site 'default' do
  port '8080'
  notifies :reload, 'apache2_service[default]', :delayed
end

apache2_service 'default' do
  action [:enable, :start]
end
```

Use the resource properties for package versions, paths, ports and configuration;
setting old `node['apache']` attributes does not configure these resources.
See the [resource reference](README.md#resources) and the runnable examples under
[`test/cookbooks/test/recipes/`](test/cookbooks/test/recipes/).

## Explicit removal

Removal only happens when you request a removal action. Normal install and create
actions keep their existing defaults.

* Configuration resources provide `:delete` to remove their generated files.
* `apache2_module :disable` retains configuration for later reuse; `:delete`
  removes the available files and enabled links. External module binaries and
  packages remain owned by their package-specific resources.
* `apache2_site :delete` removes only the enabled link;
  `apache2_default_site :delete` also removes its generated site configuration.
* `apache2_install :remove` stops/disables Apache, removes server and Perl packages,
  and deletes Apache configuration, logs, cache, lock directories and management
  scripts. Back up local configuration and logs before using it. It preserves the
  document root and shared users/groups.
* `apache2_mod_auth_cas :remove` removes its module and session cache. It retains
  shared build tools and development dependencies.

```ruby
apache2_install 'default' do
  action :remove
end
```

The removal Kitchen suite seeds an installation once, removes it, and repeats the
removal to verify that the second converge makes no changes.
