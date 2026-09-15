# apache2_mod_proxy_balancer

[Back to resource list](../README.md#resources)

Manages the Apache `mod_proxy_balancer` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

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

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_proxy_balancer 'default' do
  action :delete
end
```
