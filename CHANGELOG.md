# apache2 Cookbook Changelog

This file is used to list changes made in each version of the apache2 cookbook.

## Unreleased

## 8.0.2

- default_apache_root_group: replace with ohai root_group

## 8.0.1

- Fix not reloading service when changes in port.conf / apache2.conf

## 8.0.0 (2019-11-13)

- Fix cache_dir permission so that modules can write in their cache_dir/module/ storage space
- Latest Cookstyle changes in cookstyle 5.6.2
- Fixed bug with freebsd and suse modules adding an array to an array
- Fixed mod_ssl for suse
- Fixed docroot paths for suse

### Breaking Changes

- Renamed `:cookbook` property for `apache2_default_site` resource to `:template_cookbook`.

## 7.1.1 (2019-08-07)

- Allow overwriting cookbook for apache2_mod templates using `template_cookbook` property.

## 7.1.0 (29-05-2019)

- Add upgrading examples in UPGRADING.md
- Remove references to recipes in README.md and add a simple example
- Allow users to set / alter the default module list
- Allow users to alter the default modules configuration without rewrites
- Allow users to alter the mpm configuration without rewrites
- Fix error when passing ports as a String
- Uniform way to pass IP's in mod_info and mod_status

## 7.0.0 (05-03-2019)

- Remove all recipes
- Use `declare_resource` in `apache2_module`
- Add default value to `apache_2_mod_proxy`
- Fix spelling of `default` in `access_file_name` property in `install.rb`

## v6.0.0 (25-02-2019)

See UPGRADING.md for upgrading.

### v6 - Behaviour Changes

- Default recipe now calls the install resource
- Add helpers: for a full list see `libraries/helpers.rb`
- Remove all `mpm_` recipes. Move mpm setup to the install resource
- Allow user to set the mpm mode no matter what platform they're on
- Remove FreeBSD, openSuse & Fedora Kitchen testing
- `mod_` recipes now call `apache2_module_`
- Mod templates are now more configurable when calling the resources directly
- Add apache2_default_site resource
- Remove and document apache2_webapp resource
- Add the default_site resource for managing the default site
- Add site resource
- Remove the web_app resource as it was very perscriptive
- Add mod_ssl

### v6 - Testing/CI

- Add CircleCI and remove Travis
- Add CircleCI Orbs
- Rename test cookbook name to test
- Cleanup test integration directory
- Specs added for most helpers
- Make sysconfig parameters configurable via the install resource

### v6 - Misc Updates & Improvements

- Update README with new instructions on installing
- Set the server to listen on ports 80 and 443 by default
- Fix Options allowed in alias.conf
- Add resource documentation to documentation directory

## v5.2.1 (04-09-2018)

- Revert ports.conf fix (ports.conf that gets installed by package conflicts.

## v5.2.0 (26-08-2018)

- Drop Chef 12 support
- Add Danger and CircleCI support
- Move apache binary detection to the helpers file
- Adds apache_platform_service_name, apache_dir ,apache_conf_dir helpers
- Update kitchen configuration
- Fix ports.conf location and how its set up (#550, skadz)
- Allow httpd -t timeout to be configurable (#547, skadz)

## v5.0.1 (2017-09-01)

- Test using dokken-images in kitchen-dokken
- Fix readme section for mod_php
- Replace the existing testing.md contents with a link to the Chef testing docs
- Fix mod_ldap failing on non-RHEL platforms
- Fix mod_dav_svn to install the correct packages on Debian 8/9

## v5.0.0 (2017-07-13)

### Breaking changes

- Support for Apache 2.2 has been fully removed so we can focus on providing a solid experience for Apache 2.4 and above. This removes support for RHEL 6, SLES 11, and Debian 7

### Other changes

- Fixed openSUSE support in multiple places and added integration testing for openSUSE in Travis

## v4.0.0 (2017-07-10)

- This cookbook now requires Chef 12.1 or later
- Support for Apache 2.2 on FreeBSD has been removed
- Support for Amazon Linux < 2013.09 has been removed
- Support for end of life releases of Fedora (< 24), CentOS (5), Debian (6), Linux Mint (17), and Ubuntu (12.04) have been removed
- Removed the deprecated recipes for mod_authz_default and mod_php5
- Switched many package resources to Chef 12+ multipackage style to speed up Chef converges and reduce log clutter
- mod_cache is now enabled when using mod_cache_disk and mod_cache_socache
- The mod_cloudflare recipe now sets up the Apt repo with https
- Improved support for Amazon Linux on Chef 13 and added Test Kitchen amazon testing
- Improved support for Debian and RHEL derivative platforms
- Improved Fedora support in multiple modules
- Improved error logging for unsupported platforms in the mod_negotiation and mod_unixd recipes
- Switched from Rake for testing to Delivery local mode
- Setup integration testing with kitchen-dokken for core platforms in Travis so that every PR is now fully tested
- Removed the EC2 and Docker kitchen files now that we have kitchen-dokken setup
- Removed apt, pacman, yum, and zypper from the Berksfile as they're no longer needed for testing
- Removed testing dependencies from the Gemfile as we're testing using ChefDK
- Added integration testing for new Debian releases

## Pre 4.0 Changelog

For changelog entries pre4.0 please see [the pre-4.0 CHANGELOG](CHANGELOG-pre4.md).
