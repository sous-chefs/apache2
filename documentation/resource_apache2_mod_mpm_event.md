# apache2_mod_mpm_event

[Back to resource list](../README.md#resources)

Manages the Apache `mpm_event` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| startservers | Integer | `4` | Initial number of server processes. |
| serverlimit | Integer | `16` | Maximum number of server processes. |
| minsparethreads | Integer | `64` | Minimum number of spare worker threads. |
| maxsparethreads | Integer | `192` | Maximum number of spare worker threads. |
| threadlimit | Integer | `192` | Maximum value for ThreadsPerChild. |
| threadsperchild | Integer | `64` | Constant number of worker threads per server process. |
| maxrequestworkers | Integer | `1024` | Maximum number of simultaneous connections. |
| maxconnectionsperchild | Integer | `0` | Maximum number of requests a server process serves (0 = unlimited). |

## Examples

```ruby
apache2_mod_mpm_event '' do
  startservers 4
  maxrequestworkers 150
end
```
