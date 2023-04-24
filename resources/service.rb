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
      declare_resource(:service, 'apache2') do
        service_name new_resource.service_name
        supports status: true, restart: true, reload: true

        delayed_action resource_action
      end
    else
      declare_resource(:service, 'apache2') do
        service_name new_resource.service_name
        supports status: true, restart: true, reload: true

        action resource_action
      end
    end
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
