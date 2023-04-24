# apache2_config

[Back to resource list](../README.md#resources)

## Properties

| name                    | Type            | Default                     | Description                                                                                                    |
| ----------------------- | --------------- | --------------------------- | -------------------------------------------------------------------------------------------------------------- |
| root_group              | String          | `node['root_group']`        | Group that the root user on the box runs as. Defaults to platform specific value from ohai root_group          |
| access_file_name        | String          | `.htaccess`                 | Access filename                                                                                                |
| log_dir                 | String          | `default_log_dir`           | Log directory location. Defaults to platform specific locations, see libraries/helpers.rb                      |
| error_log               | String          | `default_error_log`         | Error log location. Defaults to platform specific locations, see libraries/helpers.rb                          |
| log_level               | String          | `warn`                      | Log level for apache2                                                                                          |
| apache_user             | String          | `default_apache_user`       | Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb    |
| apache_group            | String          | `default_apache_group`      | Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb    |
| keep_alive              | String          | On                          | Persistent connection feature of HTTP/1.1 provide long-lived HTTP sessions                                     |
| max_keep_alive_requests | Integer         | 100                         | MaxKeepAliveRequests                                                                                           |
| keep_alive_timeout      | Integer         | 5                           | KeepAliveTimeout                                                                                               |
| docroot_dir             | String          | `default_docroot_dir`       | Apache document root. Defaults to platform specific locations, see libraries/helpers.rb                        |
| timeout                 | Integer, String | 300                         | The number of seconds before receives and sends time out                                                       |
| server_name             | String          | `localhost`                 | Sets the ServerName directive                                                                                  |
| run_dir                 | String          | `default_run_dir`           | Sets the DefaultRuntimeDir directive. Defaults to platform specific locations, see libraries/helpers.rb'       |
| template_cookbook       | String          | `apache2`                   | Cookbook to source the template file from                                                                      |

## Examples

```ruby
  apache2_config 'apache2.conf' do
    access_file_name
    log_dir '/var/log/httpd/super_error_log'
    error_log '/var/log/httpd/super_error_log'
    log_level 'error'
    apache_user 'superApacheUser'
    apache_group 'superApacheUser'
    keep_alive 'On'
    max_keep_alive_requests 15
    keep_alive_timeout 100
    docroot_dir '/var/www/serverRootDir'
    timeout 60
    server_name '127.0.0.1'
  end
```
