# apache2_mod_mpm_worker

[Back to resource list](../README.md#resources)

Manages the Apache `mpm_worker` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| startservers | Integer | `4` | Initial number of server processes to start. |
| minsparethreads | Integer | `64` | Minimum number of spare worker threads. |
| maxsparethreads | Integer | `192` | Maximum number of spare worker threads. |
| threadsperchild | Integer | `64` | Constant number of worker threads per server process. |
| maxrequestworkers | Integer | `1024` | Maximum number of threads. |
| maxconnectionsperchild | Integer | `0` | Maximum number of requests a server process serves (0 = unlimited). |
| threadlimit | Integer | `192` | Maximum value for ThreadsPerChild. |
| serverlimit | Integer | `16` | Maximum value for MaxRequestWorkers / ThreadsPerChild. |

## Examples

```ruby
apache2_mod_mpm_worker '' do
  startservers 4
  threadsperchild 25
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_mpm_worker 'default' do
  action :delete
end
```
