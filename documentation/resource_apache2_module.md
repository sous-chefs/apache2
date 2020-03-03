# apache2_module

Enable or disable an Apache module in `#{apache_dir/mods-available` by calling `a2enmod` or `a2dismod` to manage the symbolic link in `#{apache_dir}/mods-enabled`. If the module has a configuration file, a template should be created in the cookbook where the definition is used. See **Examples**.

## Properties

| Name              | Type    | Default                   | Description                                                                                                  |
| ----------------- | ------- | ------------------------- | ------------------------------------------------------------------------------------------------------------ |
| name              | String  |                           | Name of the module enabled or disabled with the `a2enmod` or `a2dismod` scripts.                             |
| mod_name          | String  | `#mod_{name}.so`          | Filename of the module. Override if the module has a different filename the the default.                     |
| identifier        | String  | `#{name}_module`          | String to identify the module for the `LoadModule` directive.                                                |
| conf              | Boolean | has_config?               | The default is set by the config_file? helper. Override to set whether the module should have a config file. |
| template_cookbook | String  | apache2                   | Cookbook to source the template from.  Override this to provide your own template.                           |
| mod_conf          | Hash    | {}                        | Varables to pass to the config file template.                                                                |

## Examples

Enable the ssl module, which also has a configuration template in `templates/default/mods/ssl.conf.erb`. Simply call the resource. The cookbook contains a list of modules in `library/helpers.rb`  in the `#config_file?` method.

```ruby
apache2_module "ssl"
```

Enable the php5 module, which has a different filename than the module default:

```ruby
apache2_module "php5" do
  mod_name "libphp5.so"
end
```

Disable a module:

```ruby
apache2_module "disabled_module" do
  action :disable
end
```

Enable a module with a custom template from the `foo` cookbook:

```ruby
apache2_module "module_name" do
  conf true
  template_cookbook 'foo'
end
```

See the recipes directory for many more examples of `apache2_module`.
