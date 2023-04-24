# apache2_mod_php

[Back to resource list](../README.md#resources)

Enables apache2 module `mod_php`.

This resource will install and enable the Apache PHP module. See `apache_mod_php_package` for the platform-specific module package.
If installing PHP outside of this resource (i.e. with the [`php` cookbook](https://github.com/sous-chefs/php)), you should set `install_package` to false to avoid a possible version conflict.

**Note: call this resource directly, not through `apache2_module`!**
This resource will call `_module` with the correct identifiers for you.

## Properties

| Name             | Type   | Default                      | Description                                                                                                     |
| ---------------- | ------ | ---------------------------- | --------------------------------------------------------------------------------------------------------------- |
| module_name      | String | `apache_mod_php_modulename`  | The name of the php module.                                                                                     |
| so_filename      | String | `apache_mod_php_filename`    | The filename of the module object.                                                                              |
| package_name     | String | `apache_mod_php_package`     | The package that contains the PHP module itself, which is sometimes not included with the default PHP packages. |
| install_package  | Bool   | `true`                       | Whether to install the PHP module package.                                                                      |
