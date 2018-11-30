# conf

Writes conf files to the `conf-available` folder, and passes enabled values to `apache2_config`.

## Properties

| Name              | Type   | Default                          | Description                                                                        |
| ----------------- | ------ | -------------------------------- | ---------------------------------------------------------------------------------- |
| path              | String | `"#{apache_dir}/conf-available"` | Path to the                                                                        |
| root_group        | String | default_apache_root_group        | Platform based default for the templates root group.                               |
| template_cookbook | String | apache2                          | Cookbook to source the template from.  Override this to provide your own template. |

### Examples
Place and enable the example conf:

```ruby
apache2_conf 'example'
```

Disable the example conf:

```ruby
apache2_conf 'example' do
  action :disable
end
```

Place the example conf, which has a different path than the default (conf-*):

```ruby
apache2_conf 'example' do
  path '/random/example/path'
end
```
