# apache2_mod_wsgi

[Back to resource list](../README.md#resources)

Enables apache2 module `mod_wsgi`.

This resource will install and enable the Apache WSGI module. See `apache_mod_wsgi_package` for the platform-specific module package. By default it installs WSGI for Python 3 if available for the platform, otherwise falls back to Python 2. If installing Python and mod_wsgi outside of this resource, you should set `install_package` to `false` to avoid a possible version conflict.

**Note: call this resource directly, not through `apache2_module`!**
This resource will call `_module` with the correct identifiers for you.

## Actions

- `:create`

## Properties

| Name            | Type   | Default                    | Description                                       |
| --------------- | ------ | -------------------------- | ------------------------------------------------- |
| module_name     | String | `wsgi_module`              | The name of the wsgi module.                      |
| so_filename     | String | `apache_mod_wsgi_filename` | The filename of the module object.                |
| package_name    | String | `apache_mod_wsgi_package`  | The package that contains the WSGI module itself. |
| install_package | Bool   | `true`                     | Whether to install the WSGI module package.       |
