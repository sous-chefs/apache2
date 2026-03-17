# apache2_mod_fastcgi

[Back to resource list](../README.md#resources)

Manages the Apache `mod_fastcgi` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| fast_cgi_wrapper | String | `''` | Path to the FastCGI wrapper script. |
| add_handler | Hash | `{ 1 => 'fastcgi-script .fcgi' }` | An ordered hash of AddHandler directives. |

## Examples

```ruby
apache2_mod_fastcgi ''
```
