# apache2_mod_dav_fs

[Back to resource list](../README.md#resources)

Manages the Apache `mod_dav_fs` configuration file.

## Actions

| Action  | Description               |
| ------- | ------------------------- |
| :create | Create the configuration. |

## Properties

| Name        | Type   | Default                                         | Description                                    |
| ----------- | ------ | ----------------------------------------------- | ---------------------------------------------- |
| dav_lock_db | String | `<lock_dir>/DAVLock` (platform-specific)        | Path to the DAV lock database file.            |

## Examples

```ruby
apache2_mod_dav_fs ''
```
