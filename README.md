# apache2 Cookbook
[![Cookbook Version](https://img.shields.io/cookbook/v/apache2.svg?style=flat)](https://supermarket.chef.io/cookbooks/apache2) [![Build Status](https://travis-ci.org/sous-chefs/apache2.svg?branch=master)](https://travis-ci.org/sous-chefs/apache2) [![License](https://img.shields.io/badge/license-apache2_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

This cookbook provides a complete Debian/Ubuntu style Apache HTTPD configuration. Non-Debian based distributions such as Red Hat/CentOS, ArchLinux and others supported by this cookbook will have a configuration that mimics Debian/Ubuntu style as it is easier to manage with Chef.

Debian-style Apache configuration uses scripts to manage modules and sites (vhosts). The scripts are:

-   a2ensite
-   a2dissite
-   a2enmod
-   a2dismod
-   a2enconf
-   a2disconf

This cookbook ships with templates of these scripts for non-Debian/Ubuntu platforms. The scripts are used in the custom resources below.

## Cookbooks:
- Build Essential
  Some recipes (e.g., `apache2::mod_auth_openid`) build the module from source



Depending on your OS configuration and security policy, you may need additional recipes or cookbooks for this cookbook's recipes to converge on the node. In particular, the following Operating System settings may affect the behavior of this cookbook:

-   SELinux enabled
-   Firewalls (such as iptables, ufw, etc.)
-   Compile tools
-   3rd party repositories

On RHEL, SELinux is enabled by default. The [selinux](https://supermarket.chef.io/cookbooks/selinux) cookbook contains a `permissive` recipe that can be used to set SELinux to "Permissive" state. Otherwise, additional recipes need to be created by the user to address SELinux permissions.

To deal with firewalls Chef Software does provide an [iptables](https://supermarket.chef.io/cookbooks/iptables) and [ufw](https://supermarket.chef.io/cookbooks/ufw) cookbook but is migrating from the approach used there to a more robust solution utilizing the general [firewall](https://supermarket.chef.io/cookbooks/firewall) cookbook to setup rules. See those cookbooks' READMEs for documentation.

On ArchLinux, if you are using the `apache2::mod_auth_openid` recipe, you also need the [pacman](https://supermarket.chef.io/cookbooks/pacman) cookbook for the `pacman_aur` LWRP. Put `recipe[pacman]` on the node's expanded run list (on the node or in a role). This is not an explicit dependency because it is only required for this single recipe and platform; the pacman default recipe performs `pacman -Sy` to keep pacman's package cache updated.

## Platforms:
The following platforms and versions are tested and supported using [test-kitchen](http://kitchen.ci/)

-   Amazon Linux 2013.09+
-   Ubuntu 16.04 / 18.04
-   Debian 8/9
-   CentOS 7+
-   Fedora Latest
-   OpenSUSE Leap

### Notes for RHEL Family:
Apache2.4 support for Centos 6 is not complete and a sucessful install requires installing from source, which is in advisable. 

# Usage
Using this cookbook is relatively straightforward. It is recommended to create a project or organization specific [wrapper cookbook](https://www.chef.io/blog/2013/12/03/doing-wrapper-cookbooks-right/) and add the desired custom resources to the run list of a node. Depending on your environment, you may have multiple roles that use different recipes from this cookbook. Adjust any attributes as desired. For example, to create a basic recipe for web servers that provide both HTTP and HTTPS:

```ruby
% cat my_org/webserver.rb

apache2_install 'webserver'

apache2_module 'ssl'
```

For examples of using the definitions in your own recipes, see their respective sections below.

# Recipes
Most of the recipes in the cookbook are for enabling Apache modules. It is recommended to use custom resources directly for more control.

On RHEL Family distributions, certain modules ship with a config file with the package. The recipes here may delete those configuration files to ensure they don't conflict with the settings from the cookbook, which will use per-module configuration in `/etc/httpd/mods-enabled`.

## default
The default recipe simply includes the `apache2_install` resource. This resource is more flexible and should be used in favour of the default recipe.

# Custom Resources
## apache2_install



## apache2_conf
Writes conf files to the `conf-available` folder, and passes enabled values to `apache2_config`.

This definition should generally be called over `apache2_config`.

### Examples:
Place and enable the example conf:

```ruby
apache2_conf 'example'
```

Disable the example conf:

```ruby
apache2_conf 'example' do
  action :disable
end
```

Place the example conf, which has a different path than the default (conf-*):

```ruby
apache2_conf 'example' do
  path '/random/example/path'
end
```

## apache2_module
Enable or disable an Apache module in `#{node['apache']['dir']}/mods-available` by calling `a2enmod` or `a2dismod` to manage the symbolic link in `#{node['apache']['dir']}/mods-enabled`. If the module has a configuration file, a template should be created in the cookbook where the definition is used. See **Examples**.

### Parameters:
-   `name` - Name of the module enabled or disabled with the `a2enmod` or `a2dismod` scripts.
-   `identifier` - String to identify the module for the `LoadModule` directive. Not typically needed, defaults to `#{name}_module`
-   `enable` - Default true, which uses `a2enmod` to enable the module. If false, the module will be disabled with `a2dismod`.
-   `conf` - Default false. Set to true if the module has a config file, which will use `apache2_mod` for the file.
-   `filename` - specify the full name of the file, e.g.

### Examples:
Enable the ssl module, which also has a configuration template in `templates/default/mods/ssl.conf.erb`. Simply call the resource. The cookbook contains a list of modules in `library/helpers.rb`  in the `#config_file?` method.

```ruby
apache2_module "ssl"
```

Enable the php5 module, which has a different filename than the module default:

```ruby
apache2_module "php5" do
  filename "libphp5.so"
end
```

Disable a module:

```ruby
apache2_module "disabled_module" do
  action :disable
end
```

See the recipes directory for many more examples of `apache2_module`.

## apache2_mod

Sets up configuration file for an Apache module from a template. The template should be in the same cookbook where the definition is used. This is used by the `apache2_module` definition and is not often used directly.

This will use a template resource to write the module's configuration file in the `mods-available` under the Apache configuration directory (`node['apache']['dir']`). This is a platform-dependent location. See **apache2_module**.

### Parameters:

-   `name` - Name of the template. When used from the `apache2_module`, it will use the same name as the module.

### Examples:

Create `#{node['apache']['dir']}/mods-available/alias.conf`.

```ruby
apache2_mod "alias"
```

## apache2_site

Enable or disable a VirtualHost in `#{node['apache']['dir']}/sites-available` by calling a2ensite or a2dissite to manage the symbolic link in `#{node['apache']['dir']}/sites-enabled`.

The template for the site must be managed as a separate resource. To combine the template with enabling a site, see `web_app`.

### Parameters:

-   `name` - Name of the site.
-   `enable` - Default true, which uses `a2ensite` to enable the site. If false, the site will be disabled with `a2dissite`.

## apache2_web_app

Manage a template resource for a VirtualHost site, and enable it with `apache2_site`. This is commonly done for managing web applications such as Ruby on Rails, PHP or Django, and the default behavior reflects that. However it is flexible.

This definition includes some recipes to make sure the system is configured to have Apache and some sane default modules:

-   `apache2`
-   `apache2::mod_rewrite`
-   `apache2::mod_deflate`
-   `apache2::mod_headers`

It will then configure the template (see **Parameters** and **Examples** below), and enable or disable the site per the `enable` parameter.

### Parameters:

Current parameters used by the definition:

-   `name` - The name of the site. The template will be written to `#{node['apache']['dir']}/sites-available/#{params['name']}.conf`
-   `cookbook` - Optional. Cookbook where the source template is. If this is not defined, Chef will use the named template in the cookbook where the definition is used.
-   `template` - Default `web_app.conf.erb`, source template file.
-   `enable` - Default true. Passed to the `apache2_site` definition.

Additional parameters can be defined when the definition is called in a recipe, see **Examples**.

### Examples:

The recommended way to use the `web_app` definition is in a application specific cookbook named "my_app". The following example would look for a template named 'web_app.conf.erb' in your cookbook containing the apache httpd directives defining the `VirtualHost` that would serve up "my_app".

```ruby
web_app "my_app" do
   template 'web_app.conf.erb'
   server_name node['my_app']['hostname']
end
```

All parameters are passed into the template. You can use whatever you like. The apache2 cookbook comes with a `web_app.conf.erb` template as an example. The following parameters are used in the template:

-   `server_name` - ServerName directive.
-   `server_aliases` - ServerAlias directive. Must be an array of aliases.
-   `docroot` - DocumentRoot directive.
-   `application_name` - Used in RewriteLog directive. Will be set to the `name` parameter.
-   `directory_index` - Allow overriding the default DirectoryIndex setting, optional
-   `directory_options` - Override Options on the docroot, for example to add parameters like Includes or Indexes, optional.
-   `allow_override` - Modify the AllowOverride directive on the docroot to support apps that need .htaccess to modify configuration or require authentication.

To use the default web_app, for example:

```ruby
web_app "my_site" do
  server_name node['hostname']
  server_aliases [node['fqdn'], "my-site.example.com"]
  docroot "/srv/www/my_site"
  cookbook 'apache2'
end
```

## License

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
