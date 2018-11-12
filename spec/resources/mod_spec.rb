require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_mod_setenvif,
            :apache2_mod_reqtimeout,
            :apache2_mod_proxy,
            :apache2_mod_proxy_ftp,
            :apache2_mod_pagespeed,
            :apache2_mod_negotiation,
            :apache2_mod_mime,
            :apache2_mod_mime_magic

  platform 'ubuntu'

  context 'mod_setenvif' do
    recipe do
      apache2_mod_setenvif ''
    end

    it 'outputs the setenvif template with the correctly escaped content' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_setenvif.conf')
        .with_content(%r{BrowserMatch "Konqueror/4" redirect-carefully})
    end
  end

  context 'mod_reqtimeout' do
    recipe do
      apache2_mod_reqtimeout ''
    end

    it 'outputs the reqtimeout template with the correct hash values only' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_reqtimeout.conf')
        .with_content(/header=20-40,minrate=500/)

      is_expected.to render_file('/etc/apache2/mods-available/mod_reqtimeout.conf')
        .with_content(/body=10,minrate=500/)
    end
  end

  context 'mod_proxy' do
    recipe do
      apache2_mod_proxy ''
    end

    it 'outputs the proxy template with the correct values' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_proxy.conf')
        .with_content(/ProxyRequests Off/)
    end
  end

  context 'mod_proxy_ftp' do
    recipe do
      apache2_mod_proxy_ftp ''
    end

    it 'outputs the proxy ftp template with the correct values' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_proxy_ftp.conf')
        .with_content(/ProxyFtpDirCharset UTF-8/)
    end

    it 'should not output empty value' do
      is_expected.not_to render_file('/etc/apache2/mods-available/mod_proxy_ftp.conf')
        .with_content(/ProxyFtpEscapeWildcards/)
    end

    it 'should not output empty value' do
      is_expected.not_to render_file('/etc/apache2/mods-available/mod_proxy_ftp.conf')
        .with_content(/ProxyFtpListOnWildcards/)
    end
  end

  context 'mod_pagespeed' do
    recipe do
      apache2_mod_pagespeed ''
    end

    it 'outputs the pagespeed template with the correct values' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_pagespeed.conf')
        .with_content(/ModPagespeed on/)
        .with_content(/ModPagespeedInheritVHostConfig on/)
        .with_content(%r{AddOutputFilterByType MOD_PAGESPEED_OUTPUT_FILTER text/html})
        .with_content(/ModPagespeedInheritVHostConfig on/)
        .with_content(/ModPagespeedFileCacheInodeLimit 500000/)

      is_expected.not_to render_file('/etc/apache2/mods-available/mod_pagespeed.conf')
        .with_content(%r{AddOutputFilterByType application/xhtml+xml})
        .with_content(/ModPagespeedRewriteLevel PassThrough/)
        .with_content(/ModPagespeedDisableFilters/)
        .with_content(/ModPagespeedEnableFilters/)
        .with_content(/ModPagespeedDomain/)
        .with_content(%r{ModPagespeedLibrary 105527 ltVVzzYxo0 //ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js})
        .with_content(%r{ModPagespeedLibrary 92501 J8KF47pYOq //ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js})
        .with_content(%r{ModPagespeedLibrary 141547 GKjMUuF4PK //ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js})
        .with_content(%r{ModPagespeedLibrary 43 1o978_K0_L http://www.modpagespeed.com/rewrite_javascript.js})
    end

    it 'Creates the cache directory' do
      is_expected.to create_directory('/var/cache/mod_pagespeed/')
        .with_owner('www-data')
        .with_group('www-data')
    end
  end

  context 'mod_negotiation' do
    recipe do
      apache2_mod_negotiation ''
    end

    it 'outputs the proxy negotiation template with the correct values' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_negotiation.conf')
        .with_content(/en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv tr zh-CN zh-TW/)
    end
  end

  context 'mod_mime' do
    recipe do
      apache2_mod_mime ''
    end

    it 'outputs the mime template' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_mime.conf')
        .with_content(/AddOutputFilter INCLUDES .shtml/)
        .with_content(%r{AddType text/html .shtml})
        .with_content(/AddHandler type-map var/) 
        .with_content(/AddEncoding gzip svgz/)
    end
  end

  context 'mod_mime_magic' do
    recipe do
      apache2_mod_mime_magic ''
    end

    it 'outputs the mime template' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_mime_magic.conf')
        .with_content(%r{MIMEMagicFile /etc/apache2/magic})
    end
  end  
end
