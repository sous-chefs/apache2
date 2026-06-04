include_controls 'apache2-default'

control 'template-render' do
  case os[:family]
  when 'debian'
    describe file('/etc/apache2/apache2.conf') do
      it { should exist }
      its('content') { should match(/Use template_cookbook property in apache2_config or apache2_install to provide your own apache2.conf/) }
    end
  when 'suse'
    describe file('/etc/apache2/httpd.conf') do
      it { should exist }
      its('content') { should match(/Use template_cookbook property in apache2_config or apache2_install to provide your own apache2.conf/) }
    end
  else
    describe file('/etc/httpd/conf/httpd.conf') do
      it { should exist }
      its('content') { should match(/Use template_cookbook property in apache2_config or apache2_install to provide your own apache2.conf/) }
    end
  end
end

control 'custom-conf' do
  case os[:family]
  when 'debian'
    describe file('/etc/apache2/conf-enabled/custom.conf') do
      it { should exist }
      its('content') { should include 'IndexIgnore . .secret *.gen' }
      its('content') { should include 'IndexOptions Charset=UTF-8' }
    end
  when 'suse'
    describe file('/etc/apache2/conf-enabled/custom.conf') do
      it { should exist }
      its('content') { should include 'IndexIgnore . .secret *.gen' }
      its('content') { should include 'IndexOptions Charset=UTF-8' }
    end
  else
    describe file('/etc/httpd/conf-enabled/custom.conf') do
      it { should exist }
      its('content') { should include 'IndexIgnore . .secret *.gen' }
      its('content') { should include 'IndexOptions Charset=UTF-8' }
    end
  end
end
