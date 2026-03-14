# frozen_string_literal: true

provides :apache2_mod
unified_mode true

use '_partial/_common'

property :template, String,
         name_property: true,
         description: 'Name of the template '

action :create do
  template ::File.join(apache_dir, 'mods-available', "#{new_resource.template}.conf") do
    source "mods/#{new_resource.template}.conf.erb"
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.root_group
    mode '0644'
    variables(apache_dir: apache_dir)
    action :create
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
