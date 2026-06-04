# frozen_string_literal: true

name 'apache2'

run_list 'test::default'

cookbook 'apache2', path: '.'
cookbook 'apt', git: 'https://github.com/sous-chefs/apt.git', branch: 'main'
cookbook 'php', git: 'https://github.com/sous-chefs/php.git', branch: 'main'
cookbook 'test', path: './test/cookbooks/test'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', branch: 'main'

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end
