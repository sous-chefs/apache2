# apache2_install

[Back to resource list](../README.md#resources)

Installs apache2.

## Properties

| Name                        | Type            | Default                             | Description                                                                                                 | Allowed Values                                              |
|-----------------------------|-----------------|-------------------------------------|-------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| root_group                  | String          | `node['root_group']`                | Group that the root user on the box runs as. Defaults to platform specific value from ohai root_group       |                                                             |
| apache_user                 | String          | `default_apache_user`               | Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb |                                                             |
| apache_group                | String          | `default_apache_group`              | Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb |                                                             |
| log_dir                     | String          | `default_log_dir`                   | Log directory location. Defaults to platform specific locations, see libraries/helpers.rb                   |                                                             |
| error_log                   | String          | `default_error_log`                 | Error log location. Defaults to platform specific locations, see libraries/helpers.rb                       |                                                             |
| mpm                         | String          | `default_mpm`                       | Multi-processing Module. Defaults to platform specific locations, see libraries/helpers.rb                  |                                                             |
| mpm_conf                    | Hash            | `{}`                                | Configuration parameters for the MPM.                                                                       |                                                             |
| modules                     | [String, Array] | `default_modules`                   | Defaults modules, defaults to platform specific values, see libraries/helpers.rb                            |                                                             |
| mod_conf                    | Hash            | `{}`                                | Configuration parameters for the defaults modules, as an Hash of Hash.                                      |                                                             |
| docroot_dir                 | String          | `default_docroot_dir`               | Apache document root. Defaults to platform specific locations, see libraries/helpers.rb                     |                                                             |
| run_dir                     | String          | `default_run_dir`                   | Location for APACHE_RUN_DIR. Defaults to platform specific locations, see libraries/helpers.rb              |                                                             |
| log_level                   | String          | `warn`                              | log level for apache2                                                                                       |                                                             |
| apache_locale               | String          | `system`                            | Locale for apache2, defaults to the system locale                                                           |                                                             |
| status_url                  | String          | `http://localhost:80/server-status` | URL for status checks                                                                                       |                                                             |
| server_name                 | String          | `localhost`                         | ServerName value, set in _apache2.conf_ at the server level                                                 |                                                             |
| server_signature            | String          | `On`                                | ServerSignature value, set in _security.conf_                                                               | `[On, Off, EMail]`                                          |
| server_tokens               | String          | `Prod`                              | ServerTokens value, set in _security.conf_                                                                  | `[Major, Minor, Min, Minimal, Prod, ProductOnly, OS, Full]` |
| trace_enable                | String          | `Off`                               | TraceEnable value, set in _security.conf_                                                                   | `[On, Off, extended]`                                       |
| default_charset             | [String, Array] |                                     | AddDefaultCharset value(s), set in _charset.conf_                                                           |                                                             |
| httpd_t_timeout             | Integer         | `10`                                | Service timeout setting in seconds. Defaults to 10 seconds                                                  |                                                             |
| listen                      | [String, Array] | `[80, 443]`                         | Port to listen on. Defaults to both 80 & 443                                                                |                                                             |
| keep_alive                  | String          | `On`                                | description: 'Persistent connection feature of HTTP/1.1 provide long-lived HTTP sessions'                   | `[On, Off]`                                                 |
| max_keep_alive_requests     | Integer         | `100`                               | MaxKeepAliveRequests                                                                                        |                                                             |
| keep_alive_timeout          | Integer         | `5`                                 | KeepAliveTimeout                                                                                            |                                                             |
| access_file_name            | String          | `.htaccess`                         | Access filename                                                                                             |                                                             |
| envvars_additional_params   | Hash            | `{}`                                | Hash of additional environment variables to add to the envvars file                                         |
| sysconfig_additional_params | Hash            | `{}`                                | Hash of additional sysconfig parameters to apply to the system                                              |                                                             |
| template_cookbook           | String          | `apache2`                           | Cookbook to source the apache2.conf template from                                                           |                                                             |

## Examples

```ruby
apache2_install 'custom' do
  status_url 'status.site.org'
  template_cookbook 'my_cookbook'
end
```

```ruby
apache2_install 'default' do
  listen [ 80 ]
  mpm 'worker'
  mpm_conf(
           startservers: 10,
           serverlimit: 64,
           #maxclients    4096
           minsparethreads: 64,
           maxsparethreads: 256,
           threadsperchild: 64,
           #maxrequestsperchild 1024
           maxrequestworkers: 4096,
           maxconnectionsperchild: 1024
          )
  modules %w(status)
  mod_conf(
    status: {
      status_allow_list: %w(127.0.0.1 ::1 1.2.3.0/24),
      extended_status: 'On',
      proxy_status: 'Off'
    }
  )
  modules lazy { default_modules.delete_if { |x| x=='autoindex' } }
end
```

```ruby
apache2_install 'overrides' do
  # override the values in _security.conf_
  server_signature 'EMail'
  server_tokens 'Full'
  trace_enable 'On'
  # override the values in _charset.conf_
  default_charset 'utf-8'
end
```
