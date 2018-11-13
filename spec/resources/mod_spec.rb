require 'spec_helper'

describe 'apache2_install' do
  step_into :apache2_mod_setenvif,
            :apache2_mod_reqtimeout,
            :apache2_mod_proxy,
            :apache2_mod_proxy_ftp,
            :apache2_mod_pagespeed,
            :apache2_mod_negotiation,
            :apache2_mod_mime,
            :apache2_mod_mime_magic,
            :apache2_mod_ldap,
            :apache2_mod_include,
            :apache2_mod_fcgid,
            :apache2_mod_fastcgi,
            :apache2_mod_dir,
            :apache2_mod_deflate,
            :apache2_mod_dav_fs,
            :apache2_mod_cgid,
            :apache2_mod_cache_disk,
            :apache2_mod_autoindex,
            :apache2_mod_actions,
            :apache2_mod_status,
            :apache2_mod_alias

  platform 'ubuntu'

  context 'mod_setenvif' do
    recipe do
      apache2_mod_setenvif ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_setenvif.conf')
        .with_content(%r{BrowserMatch "Konqueror/4" redirect-carefully})
    end
  end

  context 'mod_reqtimeout' do
    recipe do
      apache2_mod_reqtimeout ''
    end

    it 'outputs template correctly' do
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

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_proxy.conf')
        .with_content(/ProxyRequests Off/)
    end
  end

  context 'mod_proxy_ftp' do
    recipe do
      apache2_mod_proxy_ftp ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_proxy_ftp.conf')
        .with_content(/ProxyFtpDirCharset UTF-8/)
    end

    it 'should not output empty value' do
      is_expected.not_to render_file('/etc/apache2/mods-available/mod_proxy_ftp.conf')
        .with_content(/ProxyFtpEscapeWildcards/)
        .with_content(/ProxyFtpListOnWildcards/)
    end
  end

  context 'mod_pagespeed' do
    recipe do
      apache2_mod_pagespeed ''
    end

    it 'outputs template correctly' do
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

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_negotiation.conf')
        .with_content(/en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv tr zh-CN zh-TW/)
    end
  end

  context 'mod_mime' do
    recipe do
      apache2_mod_mime ''
    end

    it 'outputs template correctly' do
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

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_mime_magic.conf')
        .with_content(%r{MIMEMagicFile /etc/apache2/magic})
    end
  end

  context 'mod_ldap' do
    recipe do
      apache2_mod_ldap ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_ldap.conf')
        .with_content(/Require local/)
    end
  end

  context 'mod_include' do
    recipe do
      apache2_mod_include ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_include.conf')
        .with_content(%r{AddType text/html .shtml})
        .with_content(/AddOutputFilter INCLUDES .shtml/)
    end
  end

  context 'mod_fcgid' do
    recipe do
      apache2_mod_fcgid ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_fcgid.conf')
        .with_content(/AddHandler fcgid-script .fcgi/)
        .with_content(/IPCConnectTimeout 20/)
    end
  end

  context 'mod_fastcgi' do
    recipe do
      apache2_mod_fastcgi ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_fastcgi.conf')
        .with_content(%r{FastCgiIpcDir /usr/lib/apache2/fastcgi})

      is_expected.not_to render_file('/etc/apache2/mods-available/mod_fastcgi.conf')
        .with_content(%r{FastCgiWrapper /usr/lib/apache2/suexec})
    end
  end

  context 'mod_dir' do
    recipe do
      apache2_mod_dir ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_dir.conf')
        .with_content(/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/)
    end
  end

  context 'mod_deflate' do
    recipe do
      apache2_mod_deflate ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_deflate.conf')
        .with_content(/AddOutputFilterByType/)
        .with_content(%r{AddOutputFilterByType DEFLATE image/svg\+xml})
        .with_content(%r{AddOutputFilterByType DEFLATE application/x-httpd-eruby})
    end
  end

  context 'mod_dav_fs' do
    recipe do
      apache2_mod_dav_fs ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_dav_fs.conf')
        .with_content(%r{DAVLockDB /var/lock/apache2/DAVLock})
    end
  end

  context 'mod_cgid' do
    recipe do
      apache2_mod_cgid ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_cgid.conf')
        .with_content(%r{ScriptSock /var/run/apache2/cgisock})
    end
  end

  context 'mod_cache_disk' do
    recipe do
      apache2_mod_cache_disk ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_cache_disk.conf')
        .with_content(%r{CacheRoot /var/cache/apache2/proxy})
        .with_content(/CacheDirLevels 2/)
        .with_content(/CacheDirLength 2/)
    end
  end

  context 'mod_autoindex' do
    recipe do
      apache2_mod_autoindex ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_autoindex.conf')
        .with_content(/IndexOptions FancyIndexing VersionSort HTMLTable NameWidth=\* DescriptionWidth=\* Charset=UTF-8/)
        .with_content(/ReadmeName README.html/)
        .with_content(/HeaderName HEADER.html/)
        .with_content(/IndexIgnore .\?\?\* \*~ \*# RCS CVS \*,v \*,t/)

      is_expected.not_to render_file('/etc/apache2/mods-available/mod_autoindex.conf')
        .with_content(/AddDescription "GZIP compressed tar archive" .tgz/)
    end
  end

  context 'mod_actions' do
    recipe do
      apache2_mod_actions ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_actions.conf')

      is_expected.not_to render_file('/etc/apache2/mods-available/mod_actions.conf')
        .with_content(/	Action /)
    end
  end

  context 'mod_status' do
    recipe do
      apache2_mod_status ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_status.conf')
        .with_content(/Require ip 127.0.0.1 ::1/)
        .with_content(/ExtendedStatus Off/)
        .with_content(/ProxyStatus On/)
        .with_content(%r{<Location /server-status>})
    end
  end

  context 'mod_alias' do
    recipe do
      apache2_mod_alias ''
    end

    it 'outputs template correctly' do
      is_expected.to render_file('/etc/apache2/mods-available/mod_alias.conf')
        .with_content(%r{Directory "/usr/share/apache2/icons"})
        .with_content(/Require all granted/)
    end
  end
end
