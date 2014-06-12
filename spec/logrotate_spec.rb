require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2'],
  'suse' => ['11.3']
}
#  'arch' =>

describe 'apache2::logrotate' do
# apache_service = service 'apache2' do
#   action :nothing
# end
  it 'includes the `logrotate` recipe' do
    expect(chef_run).to include_recipe('logrotate')
  end
# logrotate_app apache_service.service_name do
#   path node['apache']['log_dir']
# end
end
