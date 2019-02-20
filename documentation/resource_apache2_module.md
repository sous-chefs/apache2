# apache2_module

Enable or disable an Apache module in `#{node['apache']['dir']}/mods-available` by calling `a2enmod` or `a2dismod` to manage the symbolic link in `#{node['apache']['dir']}/mods-enabled`. If the module has a configuration file, a template should be created in the cookbook where the definition is used. See **Examples**.

## Properties

| Name              | Type    | Default                   | Description                                                                                                 |
| ----------------- | ------- | ------------------------- | ----------------------------------------------------------------------------------------------------------- |
| name              | String  |                           | Name of the module enabled or disabled with the `a2enmod` or `a2dismod` scripts.                            |
| identifier        | String  | default_apache_root_group | `#{name}_module`                                                                                            |
| template_cookbook | String  | apache2                   | Cookbook to source the template from.  Override this to provide your own template.                          |
| conf              | Boolean | has_config?               | The default is set by the config_file? helper. Override to set whether the module should have a config file |

## Examples

Enable the ssl module, which also has a configuration template in `templates/default/mods/ssl.conf.erb`. Simply call the resource. The cookbook contains a list of modules in `library/helpers.rb`  in the `#config_file?` method.

```ruby
apache2_module "ssl"
```

Enable the php5 module, which has a different filename than the module default:

```ruby
apache2_module "php5" do
  filename "libphp5.so"
end
```

Disable a module:

```ruby
apache2_module "disabled_module" do
  action :disable
end
```

See the recipes directory for many more examples of `apache2_module`.
