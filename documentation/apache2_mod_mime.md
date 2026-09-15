# apache2_mod_mime

[Back to resource list](../README.md#resources)

Manages the Apache `mod_mime` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| types_config | String | platform-specific (see helpers.rb) | Path to the MIME types configuration file. |
| add_type | Hash | (common MIME type mappings, see resource file) | An ordered hash of AddType directives. |
| add_handler | Hash | `{}` | An ordered hash of AddHandler directives. |

## Examples

```ruby
apache2_mod_mime ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_mime 'default' do
  action :delete
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `add_output_filter` | Hash | `{ 1 => 'INCLUDES .shtml' }` | Ordered AddOutputFilter directives. |
| `add_encoding` | Hash | `{ 1 => 'gzip svgz' }` | Ordered AddEncoding directives. |
| `add_language` | Hash | `{}` | Reserved property; currently not rendered. |
