# Apache2 Cookbook Agent Notes

## Full Migration Decisions (2026-09-15)

* The owner explicitly selected Full Migration and approved removing the retired
  `apache2_mod_pagespeed` resource. Remove its download helper, template and tests.
  [Apache retirement notice](https://incubator.apache.org/projects/pagespeed.html).
* The owner also explicitly approved opt-in removal actions that uninstall owned
  packages and delete configuration, logs and caches, tested only in disposable
  Kitchen containers. Never apply the removal suite to a host or live server.
* CAS removal retains shared build tools and development packages; the module,
  its source cache and session cache are removed. Main-server removal retains
  the document root and shared service accounts.
* The checkout already has no public recipes or attributes. Preserve the existing
  resource API except documented breaking changes; add explicit removal actions.
* Dependency verification initially failed because the ignored Policyfile lock
  referenced apache2 10.0.0 while metadata declared 10.1.0. Refresh local locks
  before interpreting ChefSpec failures.
* Retain distribution-provided systemd units. Service lifecycle actions must not
  replace their ExecStart, environment or security settings with generic units.

## Package and Architecture Research

* Apache HTTP Server 2.4 is installed from distribution repositories, using APT
  (`apache2`), DNF/YUM (`httpd`) or Zypper (`apache2`). No upstream binary
  repository or new GPG key is needed for the main server.
* [Ubuntu packages](https://packages.ubuntu.com/apache2) include 2.4.52 on 22.04,
  2.4.58 on 24.04 and 2.4.66 on 26.04, including amd64 and arm64 builds.
  [Debian packages](https://packages.debian.org/source/apache2) provide 2.4 on
  Debian 12 and 13; module availability must be checked separately.
* [Red Hat packaging](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index)
  supplies httpd and separately packaged modules. The same package naming is used
  by this cookbook for AlmaLinux, Rocky, Oracle, CentOS Stream and Fedora.
  Distribution architecture availability is broader than the tested Kitchen matrix;
  do not claim every module works on every architecture without integration evidence.
* [Amazon Linux 2023](https://github.com/amazonlinux/amazon-linux-2023) supports
  x86_64 and aarch64. The cookbook uses its distribution httpd package.
* [openSUSE lifecycle](https://endoflife.date/opensuse): Leap 15.6 ended support
  on 2026-04-30; move the platform target to Leap 16 rather than retaining EOL 15.
* [Apache source requirements](https://httpd.apache.org/docs/2.4/install.html)
  include a C compiler, make, APR, APR-util and PCRE development headers.
  Main-server source installation is outside this package-based API. The existing
  optional mod_auth_cas build additionally needs autoconf, automake and its
  distribution-specific development packages; retain its RHEL 10 exclusions.

This cookbook is maintained as a custom-resource-only Sous Chefs cookbook. Prefer Policyfile-based dependency resolution for local development, ChefSpec, and Kitchen work.

## Dependency And Test Workflow

* Use `chef install Policyfile.rb` to resolve cookbook dependencies.
* Use `chef exec rspec --format documentation` for unit coverage.
* Use `KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test <suite>-<platform> --destroy=always` for integration coverage.
* Security smoke checks use `semgrep --config=auto .`, `gitleaks detect --source=.`, and `trivy fs .`.

## Supported Platforms

The supported platform matrix is defined in `metadata.rb`, `kitchen.yml`, `kitchen.dokken.yml`, and `.github/workflows/ci.yml`.

* AlmaLinux 8+
* Amazon Linux 2023+
* CentOS Stream 9+
* Debian 12+
* Fedora 43+
* openSUSE Leap 16+
* Oracle Linux 8+
* Rocky Linux 8+
* Ubuntu 22.04+

Legacy Arch, FreeBSD, CentOS 7, Scientific Linux, Debian 10/11, Ubuntu 18.04/20.04, openSUSE classic, and SUSE Linux Enterprise compatibility branches are intentionally not maintained here.

## Non-Obvious Apache Constraints

* Apache module package availability depends on distribution repositories, not the cookbook alone.
* The cookbook defaults to the `event` MPM for supported Linux platforms. Resources such as `apache2_mod_php` that require prefork compatibility should be used with `apache2_install mpm 'prefork'`.
* `apache2_mod_reqtimeout` is the slow-client protection resource and should remain available in default installs.
* `apache2_mod_auth_cas` builds from source on RHEL-family, Amazon Linux, Fedora, and openSUSE platforms because native packages are not consistently available.
* RHEL 10-family platforms do not currently provide the legacy PCRE 1 development package required by the current `mod_auth_cas` source build path.
* `apache2_mod_wsgi` is excluded from Amazon Linux 2023 and openSUSE Leap CI because package/service behavior is currently unreliable there.
* `apache2_mod_php` is not available on Fedora, Amazon Linux, or RHEL-family platforms newer than 8; tests use PHP-FPM fallback coverage for those platforms.

* Dokken has no `dokken/opensuse-leap-16` image at migration time. Use the
  official `opensuse/leap:16.0` image with systemd, gzip and tar installed.
* Sous Chefs shared workflows and actions follow the repository's current `main`
  references so release and OCI-publishing behaviour stays aligned with the
  maintained cookbook baseline.
