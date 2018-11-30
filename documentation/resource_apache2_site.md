# site

Enable or disable a VirtualHost in `#{apache_dir}/sites-available` by calling a2ensite or a2dissite to manage the symbolic link in `#{apache_dir}/sites-enabled`.

The template for the site must be managed as a separate resource. For an example of this see `apache2_defualt_site` resource.

### Parameters:
-   `name` - Name of the site.
-   `enable` - Default true, which uses `a2ensite` to enable the site. If false, the site will be disabled with `a2dissite`.
