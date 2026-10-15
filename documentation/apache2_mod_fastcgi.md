# apache2_mod_fastcgi

[Back to resource list](../README.md#resources)

Manages the Apache `mod_fastcgi` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| fast_cgi_wrapper | String | `''` | Path to the FastCGI wrapper script. |
| add_handler | Hash | `{ 1 => 'fastcgi-script .fcgi' }` | An ordered hash of AddHandler directives. |

## Examples

```ruby
apache2_mod_fastcgi ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_fastcgi 'default' do
  action :delete
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `fast_cgi_ipc_dir` | String | `platform library directory + /fastcgi` | FastCGI IPC directory. |
