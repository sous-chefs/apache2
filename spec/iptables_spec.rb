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

describe 'apache2::iptables' do
  # iptables_rule 'port_apache'
  it 'creates /etc/iptables.d/port_apache' do
    expect(chef_run).to create_template('/etc/iptables.d/port_apache').with(
      :source => 'port_apache.erb',
      :backup => false
    )
  end

  let(:template) { chef_run.template('/etc/iptables.d/port_apache') }
  it 'triggers a notification by /etc/iptables.d/port_apache template to run execute[rebuild-iptables]' do
    expect(template).to notify('execute[rebuild-iptables]').to(:run)
    expect(template).to_not notify('execute[rebuild-iptables]').to(:stop)
  end
end
