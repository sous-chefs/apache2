# apache2_mod_ldap

[Back to resource list](../README.md#resources)

Manages the Apache `mod_ldap` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

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
