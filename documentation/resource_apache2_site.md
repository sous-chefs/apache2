# apache2_site

[Back to resource list](../README.md#resources)

Enable or disable a VirtualHost in `#{apache_dir}/sites-available` by calling a2ensite or a2dissite to manage the symbolic link in `#{apache_dir}/sites-enabled`.

The template for the site must be managed as a separate resource. For an example of this see `apache2_default_site` resource.

## Properties

| Name | Type   | Default | Description                         |
| ---- | ------ | ------- | ----------------------------------- |
| name | String |         | Name of the site to enable/disable. |
