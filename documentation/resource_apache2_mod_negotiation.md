# apache2_mod_negotiation

[Back to resource list](../README.md#resources)

Manages the Apache `mod_negotiation` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

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
