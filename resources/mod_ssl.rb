#
# Cookbook:: apache2
# Resource:: apache2_mod_ssl
#
# Copyright:: 2008-2017, Chef Software, Inc.
# Copyright:: 2018, Webb Agile Solutions Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include Apache2::Cookbook::Helpers

property :pass_phrase_dialog, String,
         default: lazy { pass_phrase_dialog },
         description: ''
property :session_cache, String,
        default: lazy { session_cache },
        description: ''
property :session_cache_timeout, String,
        default: '300',
        description: ''
property :cipher_suite, String,
        default: 'EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA256:EECDH:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA128-SHA:AES128-SHA',
        description: ''
property :honor_cipher_order, String,
        default: 'On',
        description: ''
property :protocol, String,
        default: '',
        description: ''
property :insecure_renegotiation, String,
        default: 'Off',
        description: ''
property :strict_sni_vhost_check, String,
        default: 'Off',
        description: ''
property :compression, String,
        default: 'Off',
        description: ''
property :use_stapling, String,
        default: 'Off',
        description: ''
property :stapling_responder_timeout, String,
        default: '5',
        description: ''
property :stapling_return_responder_errors, String,
        default: 'Off',
        description: ''
property :stapling_cache, String,
        default: 'shmcb:/var/run/ocsp(128000)',
        description: ''
property :directives, Hash,
        default: {},
        description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_ssl.conf') do
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
end

action_class do
  include Apache2::Cookbook::Helpers
end
