require 'spec_helper'

describe 'apache2::iptables' do

  # Test all defaults on all platforms
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        it 'includes the `iptables::default` recipe' do
          expect(chef_run).to include_recipe('iptables::default')
        end

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
    end
  end
end
