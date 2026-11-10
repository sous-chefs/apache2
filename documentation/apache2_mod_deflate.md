# apache2_mod_deflate

[Back to resource list](../README.md#resources)

Manages the Apache `mod_deflate` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name                      | Type  | Default                                    | Description                                                                    |
|---------------------------|-------|--------------------------------------------|--------------------------------------------------------------------------------|
| add_output_filter_by_type | Hash  | (common MIME types, see resource file)     | An ordered hash of `AddOutputFilterByType DEFLATE <types>` directives.         |
| browser_match             | Array | (common browser quirks, see resource file) | An array of `BrowserMatch` directives to disable compression for old browsers. |

## Examples

```ruby
apache2_mod_deflate ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_deflate 'default' do
  action :delete
end
```
