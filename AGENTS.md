# Apache2 Cookbook Agent Notes

This cookbook is maintained as a custom-resource-only Sous Chefs cookbook. Prefer Policyfile-based dependency resolution for local development, ChefSpec, and Kitchen work.

## Dependency And Test Workflow

- Use `chef install Policyfile.rb` to resolve cookbook dependencies.
- Use `chef exec rspec --format documentation` for unit coverage.
- Use `KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test <suite>-<platform> --destroy=always` for integration coverage.
- Security smoke checks use `semgrep --config=auto .`, `gitleaks detect --source=.`, and `trivy fs .`.

## Supported Platforms

The supported platform matrix is defined in `metadata.rb`, `kitchen.yml`, `kitchen.dokken.yml`, and `.github/workflows/ci.yml`.

- AlmaLinux 8+
- Amazon Linux 2023+
- CentOS Stream 9+
- Debian 12+
- Fedora
- openSUSE Leap 15+
- Oracle Linux 8+
- Rocky Linux 8+
- Ubuntu 22.04+

Legacy Arch, FreeBSD, CentOS 7, Scientific Linux, Debian 10/11, Ubuntu 18.04/20.04, openSUSE classic, and SUSE Linux Enterprise compatibility branches are intentionally not maintained here.

## Non-Obvious Apache Constraints

- Apache module package availability depends on distribution repositories, not the cookbook alone.
- The cookbook defaults to the `event` MPM for supported Linux platforms. Resources such as `apache2_mod_php` that require prefork compatibility should be used with `apache2_install mpm 'prefork'`.
- `apache2_mod_reqtimeout` is the slow-client protection resource and should remain available in default installs.
- `apache2_mod_auth_cas` builds from source on RHEL-family, Amazon Linux, Fedora, and openSUSE platforms because native packages are not consistently available.
- RHEL 10-family platforms do not currently provide the legacy PCRE 1 development package required by the current `mod_auth_cas` source build path.
- `apache2_mod_wsgi` is excluded from Amazon Linux 2023 and openSUSE Leap CI because package/service behavior is currently unreliable there.
- `apache2_mod_php` is not available on Fedora, Amazon Linux, or RHEL-family platforms newer than 8; tests use PHP-FPM fallback coverage for those platforms.
