# apache2_mod_reqtimeout

[Back to resource list](../README.md#resources)

Manages the Apache `mod_reqtimeout` configuration file. Use this resource to tune slow-client request timeout protection.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name                 | Type | Default                                                           | Description                                                                                                    |
|----------------------|------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| request_read_timeout | Hash | `{ '1': 'header=20-40,minrate=500', '2': 'body=10,minrate=500' }` | Ordered hash of RequestReadTimeout directives. See <https://httpd.apache.org/docs/2.4/mod/mod_reqtimeout.html> |

## Examples

```ruby
apache2_mod_reqtimeout '' do
  request_read_timeout({ '1': 'header=20-40,minrate=500', '2': 'body=20,minrate=500' })
end
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_reqtimeout 'default' do
  action :delete
end
```
