# More info at https://github.com/guard/guard#readme
scope :group => :unit

group :unit do
  guard :rubocop do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end

  guard :foodcritic, :cli => '--epic-fail any --tags ~FC007 --tags ~FC015 --tags ~FC023', :cookbook_paths => '.', :all_on_start => false do
    watch(%r{attributes/.+\.rb$})
    watch(%r{providers/.+\.rb$})
    watch(%r{recipes/.+\.rb$})
    watch(%r{resources/.+\.rb$})
    watch(%r{definitions/.+\.rb$})
  end

  guard :rspec, :cmd => 'bundle exec rspec --color --fail-fast', :all_on_start => false do
    watch(%r{^libraries/(.+)\.rb$})
    watch(%r{^spec/(.+)_spec\.rb$})
    watch(%r{^(recipes)/(.+)\.rb$})   { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')      { 'spec' }
  end
end

group :integration do
  guard :kitchen do
    watch(%r{test/.+})
    watch(%r{^recipes/(.+)\.rb$})
    watch(%r{^attributes/(.+)\.rb$})
    watch(%r{^files/(.+)})
    watch(%r{^templates/(.+)})
    watch(%r{^providers/(.+)\.rb})
    watch(%r{^resources/(.+)\.rb})
  end
end
