# apache2_mod_mime_magic

[Back to resource list](../README.md#resources)

Manages the Apache `mod_mime_magic` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| mime_magic_file | String | platform-specific (see helpers.rb) | Path to the mime magic file. |

## Examples

```ruby
apache2_mod_mime_magic ''
```
