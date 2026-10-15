# frozen_string_literal: true

# Seed an installation once so the second converge tests repeated removal.
unless ::File.exist?('/var/tmp/apache2-removal-seeded')
  apt_update 'update' if platform_family?('debian')

  apache2_install 'seed'

  apache2_service 'seed' do
    delay_start false
    action [:enable, :start]
  end

  file '/var/tmp/apache2-removal-seeded' do
    content "Apache was installed before removal.\n"
  end
end

apache2_install 'remove' do
  action :remove
end
