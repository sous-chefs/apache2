require 'spec_helper'

describe '#pagespeed_url' do
  context 'x86_64' do
    automatic_attributes['kernel']['machine'] = 'x86_64'

    recipe do
      log pagespeed_url
    end
    
     context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log('https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.rpm') }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log('https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb') }
    end
  end

  context 'x86' do
    automatic_attributes['kernel']['machine'] = 'i686'

    recipe do
      log pagespeed_url
    end

    context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log( 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_i386.rpm') }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log( 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_i386.deb') }
    end
  end
end
