unified_mode true

property :language_priority, Array,
         default: %w( en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv tr zh-CN zh-TW),
         description: ''

property :force_language_priority, String,
         default: 'Prefer Fallback',
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'negotiation.conf') do
    source 'mods/negotiation.conf.erb'
    cookbook 'apache2'
    variables(
      language_priority: new_resource.language_priority.join(' '),
      force_language_priority: new_resource.force_language_priority
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
