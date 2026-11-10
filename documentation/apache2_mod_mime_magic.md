# apache2_mod_mime_magic

[Back to resource list](../README.md#resources)

Manages the Apache `mod_mime_magic` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| mime_magic_file | String | platform-specific (see helpers.rb) | Path to the mime magic file. |

## Examples

```ruby
apache2_mod_mime_magic ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_mime_magic 'default' do
  action :delete
end
```
