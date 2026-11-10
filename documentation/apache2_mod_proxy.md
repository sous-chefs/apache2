# apache2_mod_proxy

[Back to resource list](../README.md#resources)

Installs apache2 module `mod_proxy`.

See [mod_proxy](https://httpd.apache.org/docs/trunk/mod/mod_proxy.html) for further documentation.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |


## Properties

| Name                | Type   | Default      | Description                                                                           | Allowed Values    |
| ------------------- | ------ | ------------ | ------------------------------------------------------------------------------------- | ----------------- |
| proxy_requests      | String | `Off`        |                                                                                       |                   |
| require             | String | `all denied` | [See mod_proxy access](https://httpd.apache.org/docs/trunk/mod/mod_proxy.html#access) |                   |
| add_default_charset | String | `off`        | Add the default Charachter set                                                        |                   |
| proxy_via           | String | `On`         | Enable/disable the handling of HTTP/1.1 "Via:" headers.                               | Off On Full Block |

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_proxy 'default' do
  action :delete
end
```
