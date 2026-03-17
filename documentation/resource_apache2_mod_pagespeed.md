# apache2_mod_pagespeed

[Back to resource list](../README.md#resources)

Manages the Apache `mod_pagespeed` configuration file.

## Actions

| Action | Description |
| ------ | ----------- |
| :create | Create the configuration. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| apache_user | String | platform-specific (see helpers.rb) | Apache process user. |
| apache_group | String | platform-specific (see helpers.rb) | Apache process group. |

## Examples

```ruby
apache2_mod_pagespeed ''
```
