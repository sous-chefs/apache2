# apache2 Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/apache2.svg)](https://supermarket.chef.io/cookbooks/apache2)
[![CI State](https://github.com/sous-chefs/apache2/workflows/ci/badge.svg)](https://github.com/sous-chefs/apache2/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook provides a complete Debian/Ubuntu style Apache HTTPD configuration. Non-Debian based distributions supported by this cookbook have a configuration that mimics Debian/Ubuntu style because it is easier to manage with Chef.

Debian-style Apache configuration uses scripts to manage modules and sites (vhosts). The scripts are:

- a2ensite
- a2dissite
- a2enmod
- a2dismod
- a2enconf
- a2disconf

This cookbook ships with templates of these scripts for non-Debian based platforms.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Cookbooks

Depending on your OS configuration and security policy, you may need additional cookbooks or wrapper-cookbook resources for Apache to converge and serve traffic correctly. In particular, the following operating system settings may affect the behavior of this cookbook:

- SELinux enabled
- Firewalls (such as iptables, ufw, etc.)
- Compile tools
- 3rd party repositories

On RHEL, SELinux is enabled by default. The [selinux](https://supermarket.chef.io/cookbooks/selinux) cookbook contains a `permissive` recipe that can be used to set SELinux to "Permissive" state. Otherwise, additional recipes need to be created by the user to address SELinux permissions.

To deal with firewalls Chef Software does provide an [iptables](https://supermarket.chef.io/cookbooks/iptables) and [ufw](https://supermarket.chef.io/cookbooks/ufw) cookbook but is migrating from the approach used there to a more robust solution utilizing the general [firewall](https://supermarket.chef.io/cookbooks/firewall) cookbook to setup rules. See those cookbooks' READMEs for documentation.

## Platforms

The following platforms and versions are tested and supported using [test-kitchen](https://kitchen.ci/):

- AlmaLinux 8+
- Amazon Linux 2023
- CentOS Stream 9+
- Debian 12+
- Fedora latest
- openSUSE Leap 15+
- Oracle Linux 8+
- Rocky Linux 8+
- Ubuntu 22.04+

## Usage

It is recommended to create a project or organization specific [wrapper cookbook](https://blog.chef.io/doing-wrapper-cookbooks-right) and use the desired custom resources from this cookbook. Depending on your environment, you may have multiple Policyfile run lists or wrapper-cookbook recipes using different resource combinations. Adjust resource properties as desired.

The default install now favors secure and higher-throughput generated configuration:

- `ServerSignature Off`
- `ServerTokens Prod`
- `TraceEnable Off`
- `Timeout 60`
- `KeepAliveTimeout 2`
- `MaxKeepAliveRequests 1000`
- `mpm 'event'`

These values can still be explicitly overridden. Modules that require prefork compatibility, such as `apache2_mod_php`, should be used with `apache2_install mpm 'prefork'`.

```ruby
apache2_install 'default_install' do
  notifies :restart, 'apache2_service[default]'
end

apache2_module 'headers' do
  notifies :reload, 'apache2_service[default]'
end

apache2_module 'ssl' do
  notifies :reload, 'apache2_service[default]'
end

apache2_default_site 'foo' do
  default_site_name 'my_site'
  template_cookbook 'my_cookbook'
  port '443'
  template_source 'my_site.conf.erb'
  action :enable
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action [:enable, :start]
end
```

Example wrapper cookbooks:
[basic site](test/cookbooks/test/recipes/basic_site.rb)
[ssl site](test/cookbooks/test/recipes/mod_ssl.rb)

## Resources

- [install](documentation/resource_apache2_install.md)
- [conf](documentation/resource_apache2_conf.md)
- [config](documentation/resource_apache2_config.md)
- [default_site](documentation/resource_apache2_default_site.md)
- [mod](documentation/resource_apache2_mod.md)
- [mod_actions](documentation/resource_apache2_mod_actions.md)
- [mod_alias](documentation/resource_apache2_mod_alias.md)
- [mod_auth_cas](documentation/resource_apache2_mod_auth_cas.md)
- [mod_autoindex](documentation/resource_apache2_mod_autoindex.md)
- [mod_cache_disk](documentation/resource_apache2_mod_cache_disk.md)
- [mod_cgid](documentation/resource_apache2_mod_cgid.md)
- [mod_dav_fs](documentation/resource_apache2_mod_dav_fs.md)
- [mod_deflate](documentation/resource_apache2_mod_deflate.md)
- [mod_dir](documentation/resource_apache2_mod_dir.md)
- [mod_fastcgi](documentation/resource_apache2_mod_fastcgi.md)
- [mod_fcgid](documentation/resource_apache2_mod_fcgid.md)
- [mod_include](documentation/resource_apache2_mod_include.md)
- [mod_info](documentation/resource_apache2_mod_info.md)
- [mod_ldap](documentation/resource_apache2_mod_ldap.md)
- [mod_mime](documentation/resource_apache2_mod_mime.md)
- [mod_mime_magic](documentation/resource_apache2_mod_mime_magic.md)
- [mod_mpm_event](documentation/resource_apache2_mod_mpm_event.md)
- [mod_mpm_prefork](documentation/resource_apache2_mod_mpm_prefork.md)
- [mod_mpm_worker](documentation/resource_apache2_mod_mpm_worker.md)
- [mod_negotiation](documentation/resource_apache2_mod_negotiation.md)
- [mod_pagespeed](documentation/resource_apache2_mod_pagespeed.md)
- [mod_php](documentation/resource_apache2_mod_php.md)
- [mod_proxy](documentation/resource_apache2_mod_proxy.md)
- [mod_proxy_balancer](documentation/resource_apache2_mod_proxy_balancer.md)
- [mod_proxy_ftp](documentation/resource_apache2_mod_proxy_ftp.md)
- [mod_reqtimeout](documentation/resource_apache2_mod_reqtimeout.md)
- [mod_setenvif](documentation/resource_apache2_mod_setenvif.md)
- [mod_ssl](documentation/resource_apache2_mod_ssl.md)
- [mod_status](documentation/resource_apache2_mod_status.md)
- [mod_userdir](documentation/resource_apache2_mod_userdir.md)
- [mod_wsgi](documentation/resource_apache2_mod_wsgi.md)
- [module](documentation/resource_apache2_module.md)
- [service](documentation/resource_apache2_service.md)
- [site](documentation/resource_apache2_site.md)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
