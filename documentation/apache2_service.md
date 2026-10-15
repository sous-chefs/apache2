# apache2_service

[Back to resource list](../README.md#resources)

## Actions

| Action | Description |
| --- | --- |
| `:start` | Starts the distribution systemd service. Default action. |
| `:stop` | Stops the service. |
| `:restart` | Restarts the service. |
| `:reload` | Reloads the service configuration. |
| `:enable` | Enables the service at boot. |
| `:disable` | Disables the service at boot. |

## Properties

| Name           | Type        | Default                        | Description                          |
| -------------- | ----------- | ------------------------------ | ------------------------------------ |
| `service_name` | String      | `apache_platform_service_name` | Service name to perform actions for  |
| `delay_start`  | True, False | `true`                         | Delay service start until end of run |

## Examples

```ruby
apache2_service 'default' do
  action [:enable, :start]
end
```

## Example - using notifications

```ruby
apache2_install 'default' do
  notifies :restart, 'apache2_service[default]'
end

apache2_default_site 'default' do
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action [:enable, :start]
end
```
