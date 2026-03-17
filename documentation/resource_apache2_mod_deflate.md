# apache2_mod_deflate

[Back to resource list](../README.md#resources)

Manages the Apache `mod_deflate` configuration file.

## Actions

| Action  | Description               |
|---------|---------------------------|
| :create | Create the configuration. |

## Properties

| Name                      | Type  | Default                                    | Description                                                                    |
|---------------------------|-------|--------------------------------------------|--------------------------------------------------------------------------------|
| add_output_filter_by_type | Hash  | (common MIME types, see resource file)     | An ordered hash of `AddOutputFilterByType DEFLATE <types>` directives.         |
| browser_match             | Array | (common browser quirks, see resource file) | An array of `BrowserMatch` directives to disable compression for old browsers. |

## Examples

```ruby
apache2_mod_deflate ''
```
