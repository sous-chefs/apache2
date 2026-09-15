# apache2_mod_cgid

[Back to resource list](../README.md#resources)

Manages the Apache `mod_cgid` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name        | Type   | Default                                        | Description                         |
| ----------- | ------ | ---------------------------------------------- | ----------------------------------- |
| script_sock | String | `<run_dir>/cgisock` (platform-specific)        | Path to the CGI daemon socket file. |

## Examples

```ruby
apache2_mod_cgid ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_cgid 'default' do
  action :delete
end
```
