# apache2_mod_alias

[Back to resource list](../README.md#resources)

Manages the Apache `mod_alias` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name           | Type   | Default                                             | Description                                                                                 |
|----------------|--------|-----------------------------------------------------|---------------------------------------------------------------------------------------------|
| options        | Array  | `['Indexes', 'MultiViews', 'SymLinksIfOwnerMatch']` | Options for the alias directory block.                                                      |
| icondir        | String | platform-specific (see helpers.rb)                  | The icon directory path.                                                                    |
| allow_override | Array  | `['None']`                                          | AllowOverride settings. See <https://httpd.apache.org/docs/2.4/mod/core.html#allowoverride> |
| require        | String | `'all granted'`                                     | Require directive. See <https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html#require>  |

## Examples

```ruby
apache2_mod_alias '' do
  options %w(Indexes MultiViews SymLinksIfOwnerMatch)
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_alias 'default' do
  action :delete
end
```
