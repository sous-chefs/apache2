# apache2_mod_dir

[Back to resource list](../README.md#resources)

Manages the Apache `mod_dir` configuration file.

## Actions

| Action  | Description               |
| ------- | ------------------------- |
| :create | Create the configuration. |

## Properties

| Name            | Type  | Default                                                           | Description                       |
| --------------- | ----- | ----------------------------------------------------------------- | --------------------------------- |
| directory_index | Array | `['index.html', 'index.cgi', 'index.pl', 'index.php', 'index.xhtml', 'index.htm']` | Ordered list of files to serve as directory index. |

## Examples

```ruby
apache2_mod_dir '' do
  directory_index %w(index.html index.php)
end
```
