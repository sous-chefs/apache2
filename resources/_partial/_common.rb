# frozen_string_literal: true

property :root_group, String,
         default: lazy { node['root_group'] },
         description: 'Group that the root user on the box runs as. Defaults to platform specific locations, see libraries/helpers.rb'

property :template_cookbook, String,
         default: 'apache2',
         description: 'Cookbook to source the template from. Override this to provide your own template'
