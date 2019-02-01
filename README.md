# apache2 Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/apache2.svg)](https://supermarket.chef.io/cookbooks/apache2)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/apache2/master.svg)](https://circleci.com/gh/sous-chefs/apache2)
[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

This cookbook provides a complete Debian/Ubuntu style Apache HTTPD configuration. Non-Debian based distributions such as Red Hat/CentOS, ArchLinux and others supported by this cookbook will have a configuration that mimics Debian/Ubuntu style as it is easier to manage with Chef.

Debian-style Apache configuration uses scripts to manage modules and sites (vhosts). The scripts are:

- a2ensite
- a2dissite
- a2enmod
- a2dismod
- a2enconf
- a2disconf

This cookbook ships with templates of these scripts for non-Debian/Ubuntu platforms.

## Cookbooks

- Build Essential
  This is required as some recipes (e.g., `apache2::mod_auth_openid`) build the module from source

Depending on your OS configuration and security policy, you may need additional recipes or cookbooks for this cookbook's recipes to converge on the node. In particular, the following Operating System settings may affect the behavior of this cookbook:

- SELinux enabled
- Firewalls (such as iptables, ufw, etc.)
- Compile tools
- 3rd party repositories

On RHEL, SELinux is enabled by default. The [selinux](https://supermarket.chef.io/cookbooks/selinux) cookbook contains a `permissive` recipe that can be used to set SELinux to "Permissive" state. Otherwise, additional recipes need to be created by the user to address SELinux permissions.

To deal with firewalls Chef Software does provide an [iptables](https://supermarket.chef.io/cookbooks/iptables) and [ufw](https://supermarket.chef.io/cookbooks/ufw) cookbook but is migrating from the approach used there to a more robust solution utilizing the general [firewall](https://supermarket.chef.io/cookbooks/firewall) cookbook to setup rules. See those cookbooks' READMEs for documentation.

On ArchLinux, if you are using the `apache2::mod_auth_openid` recipe, you also need the [pacman](https://supermarket.chef.io/cookbooks/pacman) cookbook for the `pacman_aur` LWRP. Put `recipe[pacman]` on the node's expanded run list (on the node or in a role). This is not an explicit dependency because it is only required for this single recipe and platform; the pacman default recipe performs `pacman -Sy` to keep pacman's package cache updated.

## Platforms

The following platforms and versions are tested and supported using [test-kitchen](http://kitchen.ci/)

- Amazon Linux 2013.09+
- Ubuntu 16.04 / 18.04
- Debian 8/9
- CentOS 7+
- Fedora Latest
- OpenSUSE Leap

### Notes for RHEL Family

Apache2.4 support for Centos 6 is not officially supported.

## Usage

It is recommended to create a project or organization specific [wrapper cookbook](https://www.chef.io/blog/2013/12/03/doing-wrapper-cookbooks-right/) and add the desired custom resources to the run list of a node. Depending on your environment, you may have multiple roles that use different recipes from this cookbook. Adjust any attributes as desired.

Example wrapper cookbooks can be found in the `test/cookbooks/test` folder.

## Recipes

This cookbook comes with recipes as a way of maintaining backwards compataility.
It is recommended to use custom resources directly for more control.

On RHEL Family distributions, certain modules ship with a config file with the package. The recipes here may delete those configuration files to ensure they don't conflict with the settings from the cookbook, which will use per-module configuration in `/etc/httpd/mods-enabled`.

## default

The default recipe simply includes the `apache2_install` resource, using all the default values. The `apache2_install` resource is more flexible and should be used in favour of the default recipe.

## Resources

- [install](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_install.md)
- [default_site](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_default_site.md)
- [site](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_site.md)
- [conf](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_conf.md)
- [config](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_config.md)
- [mod](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_mod.md)
- [module](https://github.com/sous-chefs/apache2/blob/master/documentation/resource_apache2_module.md)

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
