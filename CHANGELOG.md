# apache2 Changelog

This file is used to list changes made in each version of the apache2 cookbook.

## 8.15.9 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management


## 8.15.6 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 8.15.5 - *2023-03-02*

- Update workflows to 2.0.1
- Remove mdl and replace with markdownlint-cli2

## 8.15.4 - *2023-02-28*

Standardise files with files in sous-chefs/repo-management

## 8.15.3 - *2023-02-20*

Standardise files with files in sous-chefs/repo-management

## 8.15.2 - *2023-02-15*

## 8.15.1 - *2023-02-14*

Standardise files with files in sous-chefs/repo-management

## 8.15.0 - *2023-02-13*

Standardise files with files in sous-chefs/repo-management

## 8.14.7 - *2023-02-13*

Standardise files with files in sous-chefs/repo-management

## 8.14.6 - *2022-12-13*

Standardise files with files in sous-chefs/repo-management

## 8.14.5 - *2022-12-08*

Standardise files with files in sous-chefs/repo-management

## 8.14.4 - *2022-05-16*

- Fix GitHub workflow permissions

## 8.14.3 - *2022-04-20*

Standardise files with files in sous-chefs/repo-management

## 8.14.2 - *2022-02-03*

- Remove delivery and switch to using reusable CI workflow
- Update tested platforms
  - removed: CentOS 8, Debian 9
  - added: Rocky / Alma 8, Debian 11
- Fix mod_php on Debian 11
- Fedora fixes
  - mod-auth-cas
  - mod-wsgi
  - Drop support for mod_php

## 8.14.1 - *2021-11-03*

- Add CentOS Stream 8 to CI pipeline

## 8.14.0 - *2021-08-31*

- Add `envvars_additional_params` property to install resource

## 8.13.1 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 8.13.0 - *2021-07-09*

- Add `default_charset`, `server_signature`, `server_tokens`, and `trace_enable` to `install` resource
- Add `install_override` test suite

## 8.12.0 - *2021-07-08*

- Add `variables` property to `default_site` resource
- Convert test suites `basic_site` and `mod_wsgi` to use updated `default_site` resource

## 8.11.2 - *2021-07-06*

- Fixed error with delivery where it was expecting string interpolation incorrectly
- Fix EL8 welcome page

## 8.11.1 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 8.11.0 - *2021-05-06*

- Add missing unified_mode from mod_php and mod_wscgi
- Fix service resource restarting the service every run
- Bump minimum Chef version to 15.3 to support unified_mode

## 8.10.0 - *2021-04-09*

- Fix `apache2_mod_auth_cas` resource for all supported platforms
- Fix apache devel package name on SUSE platforms
- Fix `libexec_dir` variable in `auth_cas.load` template
- Add Integration tests for `apache2_mod_auth_cas` resource
- Add docs for `apache2_mod_auth_cas`
- Add `:source_checksum`, `:login_url`, `:validate_url`, `:directives` properties to `apache2_mod_auth_cas` resource
- Allow `apache2_mod_auth_cas` resource to be nameless
- Update `mod_auth_cas` source version to 1.2 and other various updates for source installations
- Install `mod_auth_cas` by source on CentOS 8 and SUSE platforms (distro package is not currently available)
- Include yum-epel recipe on RHEL/Amazon platforms

## 8.9.1 - *2021-03-03*

- Fix url in README

## 8.9.0 - *2021-01-27*

- Enable `options` property to pass arbitrary variables to the conf template

## 8.8.0 - *2021-01-26*

- Remove support and testing for Ubuntu 16.04

## 8.7.0 - *2020-11-20*

- Add `template_cookbook` property to `install`

## 8.6.0 (2020-10-13)

- Add `apache2_mod_wsgi` resource
- Fix backwards compatibility for SUSE with `a2enmod`

## 8.5.1 (2020-10-02)

- Add apache namespace for `site_available?` and `site_enabled?` helper methods

## 8.5.0 (2020-09-22)

- resolved cookstyle error: spec/libraries/default_modules_spec.rb:8:7 refactor: `ChefCorrectness/IncorrectLibraryInjection`
- Cookstyle Bot Auto Corrections with Cookstyle 6.17.7
- Directly include Apache2::Cookbook::Helpers in recipes and resources by default
- `config` has now `template_cookbook` property to use an external template

## 8.4.0 (2020-09-09)

- resolved cookstyle error: test/cookbooks/test/recipes/php.rb:1:1 refactor: `ChefCorrectness/IncorrectLibraryInjection`
- Allow override of package name and version in `install` resource
- Add tests for package name override

## 8.3.0 (2020-07-13)

- Add `mod_php` resource

## 8.2.1 (2020-06-29)

- Add missing lib_dir variable to `a2enmod` template

## 8.2.0 (2020-06-18)

- Updated helpers to use platform_family? when possible to simplify code
- Fixed incorrect platform version comparison logic in the helpers
- Add new platforms to the Kitchen configs
- Remove logic in the Linux helpers that checked for systemd vs. non-systemd since we only support systemd platforms now

## 8.1.2 - 2020-06-02

- resolved cookstyle error: libraries/helpers.rb:196:14 refactor: `ChefCorrectness/InvalidPlatformFamilyInCase`
- Enable unified_mode for all resources
  - This deprecates support for Chef Infra Client 14 and below

## [8.1.1] - 2020-04-12

- Add CentOS 8 to CI pipeline
- Add Debian 10 / Remove Debian 8 from CI pipeline
- Rename libexec_dir to apache_libexec_dir

## [8.1.0] - 2020-03-06

- Add 'template_cookbook' property to apache2_module
- Migrated to Github Actions for testing

### Fixed

- Cookstyle fixes

### Removed

- Removed circleci testing

## [8.0.2] - 2019-11-15

- default_apache_root_group: replace with ohai root_group

## [8.0.1] - 2019-11-15

- Fix not reloading service when changes in port.conf / apache2.conf

## [8.0.0] - 2019-11-13

- Fix cache_dir permission so that modules can write in their cache_dir/module/ storage space
- Latest Cookstyle changes in cookstyle 5.6.2
- Fixed bug with freebsd and suse modules adding an array to an array
- Fixed mod_ssl for suse
- Fixed docroot paths for suse

### Breaking Changes

- Renamed `:cookbook` property for `apache2_default_site` resource### Added

## [7.1.1] - 2019-08-07

- Allow overwriting cookbook for apache2_mod templates using `template_cookbook` property.

## [7.1.0] - 29-05-2019

- Add upgrading examples in UPGRADING.md
- Remove references to recipes in README.md and add a simple example
- Allow users to set / alter the default module list
- Allow users to alter the default modules configuration without re### Added

- Uniform way to pass IP's in mod_info and mod_status

## [7.0.0] - 05-03-2019

- Remove all recipes
- Use `declare_resource` in `apache2_module`
- Add default value to `apache_2_mod_proxy`
- Fix spelling of `default` in `access_file_name` property in `install.rb`

## [6.0.0] - 25-02-2019

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

## [5.2.1] - 04-09-2018

- Revert ports.conf fix (ports.conf that gets installed by package conflicts.

## [5.2.0] - 26-08-2018

- Drop Chef 12 support
- Add Danger and CircleCI support
- Move apache binary detection to the helpers file
- Adds apache_platform_service_name, apache_dir ,apache_conf_dir helpers
- Update kitchen configuration
- Fix ports.conf location and how its set up (#550, skadz)
- Allow httpd -t timeout to be configurable (#547, skadz)

## [5.0.1] - 2017-09-01

- Test using dokken-images in kitchen-dokken
- Fix readme section for mod_php
- Replace the existing testing.md contents with a link to the Chef testing docs
- Fix mod_ldap failing on non-RHEL platforms
- Fix mod_dav_svn to install the correct packages on Debian 8/9

## [5.0.0] - 2017-07-13

### Breaking changes

- Support for Apache 2.2 has been fully removed so we can focus on providing a solid experience for Apache 2.4 and above. This removes support for RHEL 6, SLES 11, and Debian 7

### Other changes

- Fixed openSUSE support in multiple places and added integration testing for openSUSE in Travis

## [4.0.0] - 2017-07-10

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
