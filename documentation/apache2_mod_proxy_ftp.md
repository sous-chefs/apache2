# apache2_mod_proxy_ftp

[Back to resource list](../README.md#resources)

Manages the Apache `mod_proxy_ftp` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| proxy_ftp_dir_charset | String | `'UTF-8'` | Character set for FTP directory listings. |
| proxy_ftp_escape_wildcards | String | `''` | Whether wildcards in filenames are escaped (`'on'`, `'off'`, or `''` for default). |

## Examples

```ruby
apache2_mod_proxy_ftp ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_proxy_ftp 'default' do
  action :delete
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `proxy_ftp_list_on_wildcard` | String | `''` | ProxyFtpListOnWildcard; empty omits the directive. |
