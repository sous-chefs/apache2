# apache2_mod_auth_cas

[Back to resource list](../README.md#resources)

Enables apache2 module `mod_auth_cas`.

**Note: call this resource directly, not through `apache2_module`!**
This resource will call `_module` with the correct identifiers for you.

## Actions

| Action | Description |
| --- | --- |
| `:install` | Installs and configures the managed software. Default action. |
| `:remove` | Removes owned artifacts; see Removal below. |

## Properties

| Name              | Type   | Default                                         | Description                                                                    |
| ----------------- | ------ | ----------------------------------------------- | ------------------------------------------------------------------------------ |
| `install_method`  | String | `apache_mod_auth_cas_install_method`            | Install method for Mod auth CAS                                                |
| `source_revision` | String | `v1.2`                                          | Revision for the mod auth cas source install                                   |
| `source_checksum` | String | (see resource default)                          | Checksum for the mod auth cas source install                                   |
| `login_url`       | String | `https://login.example.org/cas/login`           | The URL to redirect users when not already logged in.                          |
| `validate_url`    | String | `https://login.example.org/cas/serviceValidate` | The URL to use when validating a ticket presented by a client                  |
| `root_group`      | String | `node['root_group']`                            | Group that the root user on the box runs as.                                   |
| `apache_user`     | String | `default_apache_user`                           | Set to override the default apache2 user.                                      |
| `apache_group`    | String | `default_apache_group`                          | Set to override the default apache2 user.                                      |
| `mpm`             | String | `default_mpm`                                   | Used to determine which devel package to install                               |
| `directives`      | Hash   | `nil`                                           | Hash of optional directives to pass to the `mod_auth_cas module` configuration |

## Examples

```ruby
# Default settings
apache2_mod_auth_cas

# Setting optional CAS directives
apache2_mod_auth_cas 'default' do
  directives(
    'CASCookiePath' => "#{cache_dir}/mod_auth_cas/"
  )
end
```

## Removal

`:remove`: Removes the CAS module configuration, enabled links and session cache. For source installs it also removes the compiled module, downloaded archive and extracted source. For package installs it removes the CAS package. Shared build tools and development dependencies are retained.

```ruby
apache2_mod_auth_cas 'default' do
  action :remove
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | String | `''` | Resource label; the module configuration is shared. |
