# apache2_mod_include

[Back to resource list](../README.md#resources)

Manages the Apache `mod_include` (Server Side Includes) configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| add_type | Hash | `{ 1 => 'text/html .shtml' }` | An ordered hash of AddType directives. |
| add_output_filter | Hash | `{ 1 => 'INCLUDES .shtml' }` | An ordered hash of AddOutputFilter directives. |

## Examples

```ruby
apache2_mod_include ''
```
