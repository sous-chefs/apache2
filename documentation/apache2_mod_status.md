# apache2_mod_status

[Back to resource list](../README.md#resources)

Manages the Apache `mod_status` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| location | String | `'/server-status'` | URL path for the server status page. |
| status_allow_list | String, Array | `['127.0.0.1', '::1']` | IP addresses allowed to access the status page. |
| extended_status | String | `'On'` | ExtendedStatus directive. |
| proxy_status | String | `'Off'` | ProxyStatus directive. |

## Examples

```ruby
apache2_mod_status '' do
  status_allow_list %w(127.0.0.1 ::1 10.0.0.0/8)
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_status 'default' do
  action :delete
end
```
