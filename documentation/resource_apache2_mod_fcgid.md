# apache2_mod_fcgid

[Back to resource list](../README.md#resources)

Manages the Apache `mod_fcgid` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| add_handler | Hash | `{ 1 => 'fcgid-script .fcgi' }` | An ordered hash of AddHandler directives. |
| ipc_connect_timeout | Integer | `20` | IPC connection timeout in seconds. |

## Examples

```ruby
apache2_mod_fcgid ''
```
