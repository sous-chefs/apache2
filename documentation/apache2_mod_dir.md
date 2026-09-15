# apache2_mod_dir

[Back to resource list](../README.md#resources)

Manages the Apache `mod_dir` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name            | Type  | Default                                                                            | Description                                        |
|-----------------|-------|------------------------------------------------------------------------------------|----------------------------------------------------|
| directory_index | Array | `['index.html', 'index.cgi', 'index.pl', 'index.php', 'index.xhtml', 'index.htm']` | Ordered list of files to serve as directory index. |

## Examples

```ruby
apache2_mod_dir '' do
  directory_index %w(index.html index.php)
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_dir 'default' do
  action :delete
end
```
