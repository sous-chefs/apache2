# apache2_conf

[Back to resource list](../README.md#resources)

Writes conf files to the `conf-available` folder, and passes enabled values to `apache2_config`.

## Properties

| Name              | Type   | Default                          | Description                                                                        |
| ----------------- | ------ | -------------------------------- | ---------------------------------------------------------------------------------- |
| path              | String | `"#{apache_dir}/conf-available"` | Path to the conf-available directory                                               |
| root_group        | String | `node['root_group']`             | Platform based default for the templates root group.                               |
| template_cookbook | String | apache2                          | Cookbook to source the template from.  Override this to provide your own template. |
| options           | Hash   | server_tokens: 'Prod', server_signature: 'On', trace_enable: 'Off',             | Hash of key-value pairs to pass to the template (useful for overridden templates)  |

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

Use a custom template with discrete variables:

```ruby
apache2_conf 'my_custom_conf' do
  template_cookbook 'my_cookbook'
  options(
    index_ignore: ". .secret *.gen"
    index_charset: "UTF-8"
  )
end
```
