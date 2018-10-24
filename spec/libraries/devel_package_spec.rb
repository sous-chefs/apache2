require 'spec_helper'

describe '#apache_devel_package' do
  recipe do
    apache2_install 'package'

    log apache_devel_package
  end

  context 'redhat' do
    platform 'redhat'
    it { is_expected.to write_log('httpd-devel') }
  end

  context 'fedora' do
    platform 'redhat'
    it { is_expected.to write_log('httpd-devel') }
  end

  context 'amazon' do
    platform 'amazon', '2018.03'
    it { is_expected.to write_log('httpd24-devel') }
  end

  context 'amazon-2' do
    platform 'amazon', '2'
    it { is_expected.to write_log('httpd-devel') }
  end

  context 'suse' do
    platform 'suse'
    it { is_expected.to write_log('httpd-devel') }
  end

  context 'freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('httpd-devel') }
  end
end

context 'debian' do
  platform 'debian'

  context 'prefork' do
    recipe do
      apache2_install 'package' do
        mpm 'prefork'
      end

      log apache_devel_package
    end

    it { is_expected.to write_log('apache2-dev') }
  end

  context 'default' do
    recipe do
      apache2_install 'package'

      log apache_devel_package
    end

    it { is_expected.to write_log('apache2-prefork-dev') }
  end
end
