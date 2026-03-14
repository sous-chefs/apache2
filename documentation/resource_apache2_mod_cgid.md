# apache2_mod_cgid

[Back to resource list](../README.md#resources)

Manages the Apache `mod_cgid` configuration file.

## Actions

| Action  | Description               |
| ------- | ------------------------- |
| :create | Create the configuration. |

## Properties

| Name        | Type   | Default                                        | Description                         |
| ----------- | ------ | ---------------------------------------------- | ----------------------------------- |
| script_sock | String | `<run_dir>/cgisock` (platform-specific)        | Path to the CGI daemon socket file. |

## Examples

```ruby
apache2_mod_cgid ''
```
