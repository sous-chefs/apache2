# apache2_default_site

Controls the default site.

## Properties

| Name              | Type           | Default                        | Description                                                                                                                              |
| ----------------- | -------------- | ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| default_site_name | String         | `default-site`                 | The default site name                                                                                                                    |
| site_action       | String, Symbol | enable                         | Enable the site. Allows you to place all the configuration on disk but not enable the site                                               |
| port              | String         | `80`                           | Listen port                                                                                                                              |
| template_cookbook          | String         | `apache2`                      | Cookbook to source the template file from                                                                                                |
| server_admin      | String         | `root@localhost`               | Default site contact name                                                                                                                |
| log_level         | String         | `warn`                         | Log level for apache2                                                                                                                    |
| log_dir           | String         | `default_log_dir`              | Defaults to platform specific locations, see libraries/helpers.rb                                                                        |
| docroot_dir                 | String          | `default_docroot_dir`               | Apache document root. Defaults to platform specific locations, see libraries/helpers.rb                        |
| apache_root_group | String         | `default_apache_root_group`    | 'Group that the root user on the box runs as. Defaults to platform specific locations, see libraries/helpers.rb'                         |
| template_source   | String         | `default_site_template_source` | 'Source for the template. Defaults to #{new_resource.default_site_name}.conf on Debian flavours and welcome.conf on all other platforms' |

## Actions

- `:enable`
- `:disable`

## Examples

```ruby
apache2_default_site '' do
  default_site_name String
  site_action       [String, Symbol]
  port              String
  template_cookbook String
  server_admin      String
  log_level         String
  action :enable
end
```
