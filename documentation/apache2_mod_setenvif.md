# apache2_mod_setenvif

[Back to resource list](../README.md#resources)

Manages the Apache `mod_setenvif` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| browser_match | Array | (common browser quirks, see resource file) | Array of BrowserMatch directives for setting environment variables based on client browser. |
| browser_match_no_case | Array | `[]` | Array of BrowserMatchNoCase directives. |

## Examples

```ruby
apache2_mod_setenvif ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_setenvif 'default' do
  action :delete
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `browser_match_nocase` | Array | `[]` | BrowserMatchNoCase directives. |
| `set_env_if_no_case` | Array | `[]` | SetEnvIfNoCase directives. |
