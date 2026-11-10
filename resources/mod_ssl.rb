# frozen_string_literal: true

provides :apache2_mod_ssl
unified_mode true
include Apache2::Cookbook::Helpers

property :mod_ssl_pkg, String,
         default: 'mod_ssl',
         description: 'The name of the mod_ssl package'

property :pass_phrase_dialog, String,
         default: lazy { default_pass_phrase_dialog },
         description: 'Value for the Apache SSLPassPhraseDialog directive.'

property :session_cache, String,
        default: lazy { default_session_cache },
        description: 'Value for the Apache SSLSessionCache directive.'

property :session_cache_timeout, String,
        default: '300',
        description: 'Value for the Apache SSLSessionCacheTimeout directive.'

property :cipher_suite, String,
        default: 'EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA256:EECDH:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA128-SHA:AES128-SHA',
        description: 'Value for the Apache SSLCipherSuite directive.'

property :honor_cipher_order, String,
        default: 'On',
        description: 'Value for the Apache SSLHonorCipherOrder directive.'

property :protocol, String,
        default: 'TLSv1.2',
        description: 'Value for the Apache SSLProtocol directive.'

property :insecure_renegotiation, String,
        default: 'Off',
        description: 'Value for the Apache SSLInsecureRenegotiation directive.'

property :strict_sni_vhost_check, String,
        default: 'Off',
        description: 'Value for the Apache SSLStrictSNIVHostCheck directive.'

property :compression, String,
        default: 'Off',
        description: 'Value for the Apache SSLCompression directive.'

property :use_stapling, String,
        default: 'Off',
        description: 'Value for the Apache SSLUseStapling directive.'

property :stapling_responder_timeout, String,
        default: '5',
        description: 'Value for the Apache SSLStaplingResponderTimeout directive.'

property :stapling_return_responder_errors, String,
        default: 'Off',
        description: 'Value for the Apache SSLStaplingReturnResponderErrors directive.'

property :stapling_cache, String,
        default: 'shmcb:/var/run/ocsp(128000)',
        description: 'Value for the Apache SSLStaplingCache directive.'

property :directives, Hash,
        description: 'Additional SSL directives as a hash.'

action :create do
  if platform_family?('rhel', 'fedora', 'suse', 'amazon')
    package new_resource.mod_ssl_pkg do
      notifies :run, 'execute[generate-module-list]', :immediately
      only_if { platform_family?('rhel', 'fedora', 'amazon') }
    end
  end

  file "#{apache_dir}/conf.d/ssl.conf" do
    content '# SSL Conf is under mods-available/ssl.conf - apache2 cookbook\n'
    only_if { ::File.exist?("#{apache_dir}/conf.d") }
  end

  template ::File.join(apache_dir, 'mods-available', 'ssl.conf') do
    source 'mods/ssl.conf.erb'
    cookbook 'apache2'
    variables(
      pass_phrase_dialog: new_resource.pass_phrase_dialog,
      session_cache: new_resource.session_cache,
      session_cache_timeout: new_resource.session_cache_timeout,
      cipher_suite: new_resource.cipher_suite,
      honor_cipher_order: new_resource.honor_cipher_order,
      protocol: new_resource.protocol,
      insecure_renegotiation: new_resource.insecure_renegotiation,
      strict_sni_vhost_check: new_resource.strict_sni_vhost_check,
      compression: new_resource.compression,
      use_stapling: new_resource.use_stapling,
      stapling_responder_timeout: new_resource.stapling_responder_timeout,
      stapling_return_responder_errors: new_resource.stapling_return_responder_errors,
      stapling_cache: new_resource.stapling_cache,
      directives: new_resource.directives
    )
  end

  apache2_module 'socache_shmcb'

  %w( conf.d conf.modules.d ).each do |dir|
    directory "#{apache_dir}/#{dir}" do
      recursive true
      action :delete
    end
  end
end

action :delete do
  remove_module_configuration 'ssl'

  apache2_module 'socache_shmcb' do
    action :delete
  end

  file "#{apache_dir}/conf.d/ssl.conf" do
    backup false
    action :delete
  end

  package new_resource.mod_ssl_pkg do
    action :remove
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
