# Upgrading

All definitions have been removed and replaced with custom resources.
As a result we are now providing the default assigned names:

- apache_mod --> apache2_mod
- apache_conf --> apache2_conf
- apache_site --> apache2_site

This helps as resource behaviours have been significantly changed to remove magic where possible.

## apache_module

Having a module disabled is now an action on the resource:


```ruby
# Old Style
apache_module "disabled_module" do
  enable false
end
```

```ruby
# New Style
apache2_module "disabled_module" do
  action :disable
end
```

## What happened to all my attributes

In custom resources having & using a global variable like attributes makes the cookbook brittle and hard to test.

These have been removed in favour of tunable properties on each resource. Please see the documentation directory for all tunables.

## What happened to apache2_web_app

The `apache2_web_app` resource was a wrapper around the template resource and `apache2_site` that provided little value, and restricted the the users ability to provide all the variables possible.

It is recommended that you manage your template and call the `apache2_site` resource directly.

This leads to a simpler system, and you get more control over the variables and values you pass to the template.

An example of this behaviour can be seen in the `apache2_default_site` resource.
