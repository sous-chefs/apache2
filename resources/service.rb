# frozen_string_literal: true

provides :apache2_service
unified_mode true
include Apache2::Cookbook::Helpers

property :service_name, String,
          default: lazy { apache_platform_service_name },
          description: 'Service name to perform actions for'

property :delay_start, [true, false],
          default: true,
          description: 'Delay service start until end of run'

action_class do
  def do_service_action(resource_action)
    if %i(start restart reload).include?(resource_action) && new_resource.delay_start
      systemd_unit 'apache2.service' do
        unit_name new_resource.service_name.end_with?('.service') ? new_resource.service_name : "#{new_resource.service_name}.service"

        delayed_action resource_action
      end
    else
      systemd_unit 'apache2.service' do
        unit_name new_resource.service_name.end_with?('.service') ? new_resource.service_name : "#{new_resource.service_name}.service"

        action resource_action
      end
    end
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
