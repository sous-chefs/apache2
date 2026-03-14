# apache2_mod_proxy_ftp

[Back to resource list](../README.md#resources)

Manages the Apache `mod_proxy_ftp` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| proxy_ftp_dir_charset | String | `'UTF-8'` | Character set for FTP directory listings. |
| proxy_ftp_escape_wildcards | String | `''` | Whether wildcards in filenames are escaped (`'on'`, `'off'`, or `''` for default). |

## Examples

```ruby
apache2_mod_proxy_ftp ''
```
