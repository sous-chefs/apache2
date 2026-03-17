# apache2_mod_cache_disk

[Back to resource list](../README.md#resources)

Manages the Apache `mod_cache_disk` configuration file.

## Actions

| Action  | Description               |
|---------|---------------------------|
| :create | Create the configuration. |

## Properties

| Name                | Type   | Default                            | Description                                                                                                                 |
|---------------------|--------|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| cache_root          | String | platform-specific (see helpers.rb) | Root directory for the disk cache.                                                                                          |
| cache_dir_levels    | String | `'2'`                              | Number of sub-directory levels in the cache. See <https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachedirlevels> |
| cache_dir_length    | String | `'1'`                              | Number of characters in sub-directory names. See <https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachedirlength> |
| cache_max_file_size | String | `'1000000'`                        | Maximum size of a cached file in bytes. See <https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachemaxfilesize>    |

## Examples

```ruby
apache2_mod_cache_disk '' do
  cache_root '/var/cache/apache2/mod_cache_disk'
end
```
