# apache2_mod_info

[Back to resource list](../README.md#resources)

Manages the Apache `mod_info` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| info_allow_list | String, Array | `['127.0.0.1', '::1']` | IP addresses allowed to access `/server-info`. |

## Examples

```ruby
apache2_mod_info '' do
  info_allow_list %w(127.0.0.1 ::1 10.0.0.0/8)
end
```
