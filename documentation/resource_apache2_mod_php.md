# apache2_mod_php

Enables apache2 module `mod_php`.

This resource assumes that php has already been installed with the [`php` cookbook](https://github.com/sous-chefs/php).
However, this resource will install the specific apache2 php module package if needed, see the `apache_mod_php_package` helper.

**Note: call this resource directly, not through `apache2_module`!**
This resource will call `_module` with the correct identifiers for you.

## Properties

| Name         | Type   | Default                      | Description                         |
| ------------ | ------ | ---------------------------- | ----------------------------------- |
| module_name  | String | `apache_mod_php_modulename`  | The name of the php module.         |
| so_filename  | String | `apache_mod_php_filename`    | The filename of the module object.  |
