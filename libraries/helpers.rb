module Apache2
  module Helpers
    def basic_web_app(name, docroot)
      name_clean = name.gsub('_', '-')
      web_app = {
        port: 80,
        server_name: name_clean,
        server_aliases: ["#{name_clean}.localhost.dev"],
        docroot: docroot,
        directories:   { docroot => {
            'Options' => 'FollowSymLinks',
            'AllowOverride' => 'None',
            'Order' => 'allow,deny',
            'Allow' => 'from all'
          },
          '/' => {
            'Options' => 'FollowSymLinks',
            'AllowOverride' => 'None'
          }
        },
        locations:   { '/server-status' => {
            'SetHandler' => 'server-status',
            'Order' => 'Deny,Allow',
            'Deny' => 'from all',
            'Allow' => 'from 127.0.0.1'
          }
        },
        log_level: 'info',
        error_log: "#{node['apache']['log_dir']}/#{name}-error.log",
        custom_log:  "#{node['apache']['log_dir']}/#{name}-access.log combined",
        rewrite_engine: 'on',
        rewrite: [
          {
            'conditions' => [
              "%{HTTP_HOST} !^#{name_clean}.localhost.dev [NC]",
              '%{HTTP_HOST} !^$'
            ],
            'rules' => [
              "^/(.*)$ http://#{name_clean}.localhost.dev/$1 [L,R=301]"
            ]
          },
          {
            'conditions' => [
              '%{DOCUMENT_ROOT}/system/maintenance.html -f',
              '%{SCRIPT_FILENAME} !maintenance.html'
            ],
            'rules' => [
              '^.*$ /system/maintenance.html [L]'
            ]
          }
        ]
      }
      if node['apache']['version'] == '2.4'
        web_app[:log_level] = 'info rewrite:trace1'
        web_app[:directories][docroot] = {
          'Options' => 'FollowSymLinks',
          'AllowOverride' => 'None',
          'Require' => 'all granted'
        }
        web_app[:locations]['/server-status'] = {
          'Require' => 'local'
        }
      else
        web_app[:rewrite_log] = "#{node['apache']['log_dir']}/#{name}-rewrite.log"
        web_app[:rewrite_log_level] = 0
      end
      web_app
    end

    def default_web_app
      web_app = {
        port: 80,
        server_admin: node['apache']['contact'],
        docroot: node['apache']['docroot_dir'],
        script_alias: "/cgi-bin/ #{node['apache']['cgibin_dir']}/",
        directories:   { "#{node['apache']['docroot_dir']}/" => {
            'Options' => 'Indexes FollowSymLinks MultiViews',
            'AllowOverride' => 'None',
            'Order' => 'allow,deny',
            'Allow' => 'from all'
          },
          '/' => {
            'Options' => 'FollowSymLinks',
            'AllowOverride' => 'None'
          },
          node['apache']['cgibin_dir'] => {
            'Options' => 'ExecCGI -MultiViews +SymLinksIfOwnerMatch',
            'AllowOverride' => 'None',
            'Order' => 'allow,deny',
            'Allow' => 'from all'
          },
          '/usr/share/doc/' => {
            'Options' => 'Indexes MultiViews FollowSymLinks',
            'AllowOverride' => 'None',
            'Order' => 'deny,allow',
            'Deny' => 'from all',
            'Allow' => 'from 127.0.0.0/255.0.0.0 ::1/128'
          }
        },
        error_log: "#{node['apache']['log_dir']}/#{node['apache']['error_log']}",
        log_level: 'warn',
        custom_log:  "#{node['apache']['log_dir']}/#{node['apache']['access_log']} combined",
        server_signature: 'On',
        aliases: {
          '/doc/' => '/usr/share/doc/'
        }
      }
      if %w[rhel fedora].include?(node['platform_family'])
        web_app['location_matches'] = [
          {
            'location' => '^/+$',
            'directives' => {
              'Options' => '-Indexes',
              'ErrorDocument' => '403 /error/noindex.html'
            }
          }
        ]
      end
      web_app
    end
  end
end
