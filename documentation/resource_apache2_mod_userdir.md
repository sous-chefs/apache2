# apache2_mod_userdir

[Back to resource list](../README.md#resources)

Manages the Apache `mod_userdir` configuration file, which enables per-user web directories.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| public_html_dir | String | `'/home/*/public_html'` | UserDir directive — path to user public HTML directories. |
| options | String | `'MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec'` | Directory options for user directories. |
| allow_override | String | `'FileInfo AuthConfig Limit Indexes'` | AllowOverride settings. See https://httpd.apache.org/docs/2.4/mod/core.html#allowoverride |

## Examples

```ruby
apache2_mod_userdir '' do
  public_html_dir '/home/*/public_html'
end
```
