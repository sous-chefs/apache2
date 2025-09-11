# Apache2 Chef Cookbook

This repository contains the Chef cookbook for Apache HTTP Server management. It provides Debian/Ubuntu style Apache configuration across multiple platforms with resources for managing modules, sites, configurations, and service lifecycle.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap Environment
- Install Ruby 3.2+ with development tools:
  - `sudo apt update && sudo apt install -y ruby-bundler ruby-dev build-essential nodejs npm`
- Install Chef development tools (user gems due to permission constraints):
  - `gem install --user-install berkshelf cookstyle chefspec`
  - `export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"`
- Install additional linting tools:
  - `npm install -g markdownlint-cli2`

**NETWORK LIMITATION CRITICAL**: Berkshelf dependency resolution fails due to network restrictions (`berks install` cannot access supermarket.chef.io). Development and testing must work without external cookbook dependencies.

### Linting and Code Quality
- **Cookstyle (Ruby linting)**: `cookstyle .` -- takes 5 seconds. NEVER use `--auto-correct` as it can introduce syntax errors.
- **YAML linting**: `yamllint .` -- takes <1 second
- **Markdown linting**: `markdownlint-cli2 "**/*.md"` -- takes 1 second
- **CRITICAL**: Always run `cookstyle .` before committing. Currently shows 17 style offenses that should NOT be auto-corrected due to syntax risks.

### Testing Status
- **Unit Tests**: RSpec with ChefSpec has dependency conflicts and cannot run reliably in this environment
- **Integration Tests**: Test Kitchen requires Docker/Vagrant and external dependencies (network restricted)
- **CI Environment**: Uses GitHub Actions with Chef Workstation, Dokken containers, and matrix testing across platforms
- **Available Validation**: Linting (Cookstyle, YAML, Markdown) works reliably

### Build and Dependency Management
- **Berkshelf**: `berks install` -- FAILS due to network restrictions (cannot access supermarket.chef.io)
- **Dependencies**: Single dependency on `yum-epel` cookbook (defined in metadata.rb)
- **Platforms Supported**: Debian, Ubuntu, RHEL, CentOS, Fedora, Amazon, Scientific, FreeBSD, SUSE, OpenSUSE, Arch
- **Chef Version**: Requires Chef >= 15.3

## Validation Scenarios
- **NEVER attempt to auto-correct Cookstyle issues** - manual review required due to syntax error risks
- **Always lint before committing**: `cookstyle . && yamllint . && markdownlint-cli2 "**/*.md"`
- **Manual testing**: Due to environment limitations, code changes must be validated through careful review and linting only
- **CI will run full integration tests**: 9 test suites across 13 platform combinations in GitHub Actions

## Common Tasks

### Repository Structure
```
/home/runner/work/apache2/apache2/
├── resources/           # Chef resources (install.rb, service.rb, mod_*.rb, etc.)
├── libraries/           # Helper functions (helpers.rb)
├── templates/           # Configuration templates (.erb files)
├── test/               # Test cookbooks and integration tests
│   ├── cookbooks/test/ # Test recipes
│   └── integration/    # InSpec integration tests
├── spec/               # RSpec unit tests (ChefSpec)
├── documentation/      # Resource documentation
├── metadata.rb         # Cookbook metadata and dependencies
├── kitchen.yml         # Test Kitchen configuration
├── kitchen.dokken.yml  # Docker-based testing config
└── Berksfile          # Berkshelf dependency management
```

### Key Files to Reference
- **metadata.rb**: Cookbook version, dependencies, supported platforms
- **libraries/helpers.rb**: Platform-specific defaults and helper methods
- **resources/install.rb**: Main Apache installation resource
- **resources/service.rb**: Apache service management
- **resources/mod_*.rb**: Apache module management resources
- **test/cookbooks/test/recipes/**: Example usage patterns

### Workflow Commands
```bash
# Set up environment
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"

# Lint everything before changes
cookstyle .
yamllint .
markdownlint-cli2 "**/*.md"

# View test examples
cat test/cookbooks/test/recipes/default.rb
cat test/cookbooks/test/recipes/basic_site.rb

# Check integration test scenarios
ls test/integration/*/controls/
```

### Resource Usage Examples
See `test/cookbooks/test/recipes/` for working examples:
- **Basic Apache**: `default.rb` - Install, configure service, manage default site
- **SSL Configuration**: `mod_ssl.rb` - SSL module and site setup  
- **PHP Integration**: `php.rb` - PHP module configuration
- **Custom Modules**: `module_template.rb` - Custom module management

### Platform-Specific Notes
- **RHEL/CentOS**: Uses `httpd` service name, `/etc/httpd/` config path
- **Debian/Ubuntu**: Uses `apache2` service name, `/etc/apache2/` config path
- **FreeBSD**: Uses `apache24` service name
- Helper functions in `libraries/helpers.rb` abstract platform differences

### Limitations in This Environment
- **NO network access**: Cannot resolve external dependencies or test actual Apache installation
- **NO Chef Workstation**: Cannot run `chef exec` commands
- **NO working unit tests**: ChefSpec dependency conflicts prevent RSpec execution
- **NO integration testing**: Test Kitchen requires external resources
- **Cookstyle auto-correction DANGEROUS**: Manual review required, can introduce syntax errors

### CI Integration Notes
- GitHub Actions uses `actionshub/chef-install` to install Chef Workstation
- Runs on Ubuntu with Chef licensing: `CHEF_LICENSE: accept-no-persist`
- Full matrix testing: 9 test suites × 13 platforms = 117 test combinations
- Uses Dokken containers for fast, isolated testing environment
- Shared workflow from sous-chefs/.github repository handles lint-unit phase

**TIMING EXPECTATIONS**:
- Cookstyle linting: ~5 seconds
- YAML linting: <1 second  
- Markdown linting: ~1 second
- Dependency resolution: FAILS (network restricted)
- Unit tests: FAILS (dependency conflicts)
- Integration tests: UNAVAILABLE (requires external resources)

**REMEMBER**: This cookbook manages Apache HTTP server across multiple platforms. Focus on resource definitions, template logic, and platform compatibility when making changes. The extensive CI matrix will validate functionality across all supported platforms.