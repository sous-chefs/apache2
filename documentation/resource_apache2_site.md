# site

Enable or disable a VirtualHost in `#{apache_dir}/sites-available` by calling a2ensite or a2dissite to manage the symbolic link in `#{apache_dir}/sites-enabled`.

The template for the site must be managed as a separate resource. For an example of this see `apache2_default_site` resource.

## Properties

- `site_name` - Name of the site to enable/disable.
