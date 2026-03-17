# apache2_mod_mime

[Back to resource list](../README.md#resources)

Manages the Apache `mod_mime` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| types_config | String | platform-specific (see helpers.rb) | Path to the MIME types configuration file. |
| add_type | Hash | (common MIME type mappings, see resource file) | An ordered hash of AddType directives. |
| add_handler | Hash | `{}` | An ordered hash of AddHandler directives. |

## Examples

```ruby
apache2_mod_mime ''
```
