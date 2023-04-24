# apache2_mod

[Back to resource list](../README.md#resources)

Sets up configuration file for an Apache module from a template. The template should be in the same cookbook where the definition is used. This is used by the `apache2_module` definition and is not often used directly.

This will use a template resource to write the module's configuration file in the `mods-available` under the Apache configuration directory (`apache_dir`). This is a platform-dependent location.

## Properties

| Name         | Type   | Default                     | Description                                                            |
| ------------ | ------ | --------------------------- | ---------------------------------------------------------------------- |
| `template`   | String |                             | Name of the template                                                   |
| `root_group` | String | `node['root_group']`        | Set to override the platforms default root group for the template file |
| `template_cookbook`   | String | `apache2`                   | Cookbook containing the template file

## Examples

Create `#{apache_dir}/mods-available/alias.conf`.

```ruby
apache2_mod "alias"
```
