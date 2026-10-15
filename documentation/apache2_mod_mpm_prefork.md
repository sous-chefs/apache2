# apache2_mod_mpm_prefork

[Back to resource list](../README.md#resources)

Manages the Apache `mpm_prefork` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| startservers | Integer | `16` | Number of server processes to start. |
| minspareservers | Integer | `16` | Minimum number of spare server processes. |
| maxspareservers | Integer | `32` | Maximum number of spare server processes. |
| serverlimit | Integer | `256` | Maximum value of MaxRequestWorkers. |
| maxrequestworkers | Integer | `256` | Maximum number of server processes allowed to start. |
| maxconnectionsperchild | Integer | `10000` | Maximum number of requests a server process serves. |

## Examples

```ruby
apache2_mod_mpm_prefork '' do
  startservers 8
  maxrequestworkers 256
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_mpm_prefork 'default' do
  action :delete
end
```
