# apache2_site

[Back to resource list](../README.md#resources)

Enable or disable a VirtualHost in `#{apache_dir}/sites-available` by calling a2ensite or a2dissite to manage the symbolic link in `#{apache_dir}/sites-enabled`.

The template for the site must be managed as a separate resource. For an example of this see `apache2_default_site` resource.

## Actions

| Action | Description |
| --- | --- |
| `:enable` | Enables the managed site or configuration. Default action. |
| `:disable` | Disables the managed configuration. |
| `:delete` | Removes owned artifacts; see Removal below. |


## Properties

| Name | Type   | Default | Description                         |
| ---- | ------ | ------- | ----------------------------------- |
| name | String |         | Name of the site to enable/disable. |

## Removal

`:delete`: Removes the enabled site link. The site configuration belongs to its declaring template or apache2_default_site resource and is retained.

```ruby
apache2_site 'default' do
  action :delete
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `site_name` | String | `resource name` | Name of the site to enable or disable. |
