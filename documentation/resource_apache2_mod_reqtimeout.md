# apache2_mod_reqtimeout

[Back to resource list](../README.md#resources)

Manages the Apache `mod_reqtimeout` configuration file.

## Actions

| Action  | Description               |
|---------|---------------------------|
| :create | Create the configuration. |

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
