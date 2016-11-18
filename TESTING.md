This cookbook uses a variety of testing components:

- Unit tests: [ChefSpec](http://code.sethvargo.com/chefspec/)
- Integration tests: [Test Kitchen](http://kitchen.ci/)
- Chef Style lints: [Foodcritic](http://www.foodcritic.io/)
- Ruby Style lints: [cookstyle](https://github.com/chef/cookstyle)


Prerequisites
-------------
You can install the [Chef Development Kit (Chef-DK)](http://downloads.chef.io/chef-dk/) to more easily install the above components.

You must also have Vagrant and VirtualBox installed:

- [Vagrant](https://vagrantup.com)
- [VirtualBox](https://virtualbox.org)


Development
-----------
1. Clone the git repository from GitHub:

   - `git clone git@github.com:sous-chefs/apache2.git`

2. Install the dependencies using bundler:

   - `chef exec bundle install --path ../vendor`

3. Create a branch for your changes:

   - `git checkout -b my_bug_fix`

4. Make any changes
5. Write tests to support those changes. It is highly recommended you write both unit and integration tests.
6. Run the tests:

    - `chef exec bundle exec rspec`
    - `chef exec bundle exec foodcritic .`
    - `chef exec bundle exec rubocop`
    - `chef exec bundle exec kitchen test`

7. Assuming the tests pass, open a Pull Request on GitHub

For more information, see [the cookbooks Contribution Guidelines](https://github.com/sous-chefs/apache2/blob/master/CONTRIBUTING.md)
