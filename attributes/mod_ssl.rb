#
# Cookbook Name:: apache2
# Attributes:: mod_ssl
#
# Copyright 2012-2013, Opscode, Inc.
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

default['apache']['mod_ssl']['protocol']               = 'all -SSLv2 -SSLv3'
default['apache']['mod_ssl']['cipher_suite'] = 'EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4!aNULL!eNULL!LOW!3DES!MD5!EXP!PSK!SRP!DSS'
default['apache']['mod_ssl']['honor_cipher_order']     = 'On'
default['apache']['mod_ssl']['insecure_renegotiation'] = 'Off'
default['apache']['mod_ssl']['strict_sni_vhost_check'] = 'Off'
default['apache']['mod_ssl']['session_cache_timeout']  = 300
default['apache']['mod_ssl']['compression'] = 'Off'
default['apache']['mod_ssl']['use_stapling'] = 'Off'
default['apache']['mod_ssl']['stapling_responder_timeout'] = 5
default['apache']['mod_ssl']['stapling_return_responder_errors'] = 'Off'
default['apache']['mod_ssl']['stapling_cache'] = 'shmcb:/var/run/ocsp(128000)'
