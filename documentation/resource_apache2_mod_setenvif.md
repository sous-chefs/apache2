# apache2_mod_setenvif

[Back to resource list](../README.md#resources)

Manages the Apache `mod_setenvif` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| browser_match | Array | (common browser quirks, see resource file) | Array of BrowserMatch directives for setting environment variables based on client browser. |
| browser_match_no_case | Array | `[]` | Array of BrowserMatchNoCase directives. |

## Examples

```ruby
apache2_mod_setenvif ''
```
