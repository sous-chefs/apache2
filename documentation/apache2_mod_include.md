# apache2_mod_include

[Back to resource list](../README.md#resources)

Manages the Apache `mod_include` (Server Side Includes) configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| add_type | Hash | `{ 1 => 'text/html .shtml' }` | An ordered hash of AddType directives. |
| add_output_filter | Hash | `{ 1 => 'INCLUDES .shtml' }` | An ordered hash of AddOutputFilter directives. |

## Examples

```ruby
apache2_mod_include ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_include 'default' do
  action :delete
end
```
