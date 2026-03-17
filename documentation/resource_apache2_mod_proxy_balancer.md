# apache2_mod_proxy_balancer

[Back to resource list](../README.md#resources)

Manages the Apache `mod_proxy_balancer` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| status_location | String | `'/balancer-manager'` | URL path for the balancer manager status page. |
| set_handler | String | `'balancer-manager'` | Handler for the balancer manager location. |
| require | String | `'all denied'` | Access control for the balancer manager location. |

## Examples

```ruby
apache2_mod_proxy_balancer '' do
  require 'ip 127.0.0.1'
end
```
