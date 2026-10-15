# apache2_mod_negotiation

[Back to resource list](../README.md#resources)

Manages the Apache `mod_negotiation` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| language_priority | Array | `['en', 'ca', 'cs', 'da', ...]` | Precedence order of languages when no preference is given. |
| force_language_priority | String | `'Prefer Fallback'` | Action when there is no acceptable language match. |

## Examples

```ruby
apache2_mod_negotiation '' do
  language_priority %w(en fr de)
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_negotiation 'default' do
  action :delete
end
```
