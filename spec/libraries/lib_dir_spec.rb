require 'spec_helper'

describe '#lib_dir' do
  context 'x86_64' do
    automatic_attributes['kernel']['machine'] = 'x86_64'

    recipe do
      log lib_dir
    end

    context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log('/usr/lib64/httpd') }
    end

    context 'fedora' do
      platform 'redhat'
      it { is_expected.to write_log('/usr/lib64/httpd') }
    end

    context 'amazon' do
      platform 'amazon'
      it { is_expected.to write_log('/usr/lib64/httpd') }
    end

    context 'suse' do
      platform 'suse'
      it { is_expected.to write_log('/usr/lib64/apache2') }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log('/usr/lib/apache2') }
    end

    context 'arch' do
      platform 'arch'
      it { is_expected.to write_log('/usr/lib/httpd') }
    end

    context 'freebsd' do
      platform 'freebsd'
      it { is_expected.to write_log('/usr/local/libexec/apache24') }
    end
  end

  context 'x86' do
    automatic_attributes['kernel']['machine'] = 'i686'

    recipe do
      log lib_dir
    end

    context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log('/usr/lib/httpd') }
    end

    context 'fedora' do
      platform 'redhat'
      it { is_expected.to write_log('/usr/lib/httpd') }
    end

    context 'amazon' do
      platform 'amazon'
      it { is_expected.to write_log('/usr/lib/httpd') }
    end

    context 'suse' do
      platform 'suse'
      it { is_expected.to write_log('/usr/lib/apache2') }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log('/usr/lib/apache2') }
    end

    context 'arch' do
      platform 'arch'
      it { is_expected.to write_log('/usr/lib/httpd') }
    end

    context 'freebsd' do
      platform 'freebsd'
      it { is_expected.to write_log('/usr/local/libexec/apache24') }
    end
  end
end
