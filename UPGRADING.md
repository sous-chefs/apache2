# Upgrading

For the current breaking changes and removal actions, see [migration.md](migration.md).

All definitions have been removed and replaced with custom resources.
As a result we are now providing the default assigned names:

* apache_mod --> apache2_mod
* apache_conf --> apache2_conf
* apache_site --> apache2_site

This helps as resource behaviours have been significantly changed to remove magic where possible.

## apache_module

Having a module disabled is now an action on the resource:

```ruby
# Old Style
apache_module "disabled_module" do
  enable false
end
```

```ruby
# New Style
apache2_module "disabled_module" do
  action :disable
end
```

## Where did the apache2 recipes go

Recipes are now modules, so your cookbook pattern will go from

```ruby
include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_ssl'
```

to

```ruby
apache2_install 'default_install'
apache2_module 'headers'
apache2_module 'proxy'
apache2_module 'proxy_http'
apache2_module 'rewrite'
apache2_module 'ssl'
```

## What happened to all my attributes

In custom resources having & using a global variable like attributes makes the cookbook brittle and hard to test.

These have been removed in favour of tunable properties on each resource. Please see the documentation directory for all tunables.

## What happened to apache2_web_app

The `apache2_web_app` resource was a wrapper around the template resource and `apache2_site` that provided little value, and restricted the the users ability to provide all the variables possible.

It is recommended that you manage your template and call the `apache2_site` resource directly.

This leads to a simpler system, and you get more control over the variables and values you pass to the template.

Here are the modifications you will need to make:

```ruby
web_app 'ssl_redirect' do
  server_name node['hostname']
  server_port '80'
  docroot '/var/www/'
  template 'ssl_redirect.conf.erb'
  notifies :restart, 'service[apache2]', :delayed
end
```

to

```ruby
apache2_default_site 'ssl_redirect' do
  default_site_name 'ssl_redirect'
  cookbook 'my_cookbook'
  port '80'
  template_source 'ssl_redirect.conf.erb'
  action :enable
end
```

A further example of this behaviour can be seen in the `apache2_default_site` resource.

## The service resource

Declare `apache2_service` explicitly and send notifications to that custom resource:

```ruby
apache2_service 'default' do
  action [:enable, :start]
end

apache2_module 'headers' do
  notifies :reload, 'apache2_service[default]', :delayed
end
```
