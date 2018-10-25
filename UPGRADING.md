# Upgrading
All definitions have been removed and replaced with custom resources. 
As a result we are now providing the default assigned names:

-  apache_mod --> apache2_mod
-  apache_conf --> apache2_conf
-  web_app --> apache2_web_app
-  apache_site --> apache2_site

##apache_module
Having a module disabled is now an action on the resource:

```ruby
apache_module "disabled_module" do
  enable false
end
apache2_module "disabled_module" do
  action :disable
end
```

## What happened to all my attributes?
In custom resources having & using a global variable like attributes makes the cookbook brittle and hard to test. 

These have been removed in favour of tunable properties on each resource
