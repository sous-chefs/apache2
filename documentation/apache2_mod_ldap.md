# apache2_mod_ldap

[Back to resource list](../README.md#resources)

Manages the Apache `mod_ldap` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| location | String | `'/ldap-status'` | URL path for the LDAP status page. |
| set_handler | String | `'ldap-status'` | Handler for the LDAP status location. |
| require | String | `'all denied'` | Access control for the LDAP status location. |

## Examples

```ruby
apache2_mod_ldap ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_ldap 'default' do
  action :delete
end
```
