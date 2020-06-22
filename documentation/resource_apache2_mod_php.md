# apache2_mod_php

Enables apache2 module `mod_php`.

This resource assumes that php has already been installed with the [`php` cookbook](https://github.com/sous-chefs/php).

**Note: call this resource directly, not through `apache2_module`!**
This resource will call `_module` with the correct identifiers for you.

## Properties

| Name         | Type   | Default                                     | Description                         |
| ------------ | ------ | ------------------------------------------- | ----------------------------------- |
| module_name  | String | `php#{node['php']['version'].to_i}_module`  | The name of the php module.         |
| so_filename  | String | `libphp#{node['php']['version'].to_i}.so`   | The filename of the module object.  |

