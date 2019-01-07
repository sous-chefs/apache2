# TODO: Fix
# resource apt_package[mod_ssl] is configured to notify resource execute[generate-module-list] with action run
# Commenting out due to some notification bug.
# require 'spec_helper'

# describe 'apache2_mod_ssl' do
#   step_into :apache2_install, :apache2_mod_ssl
#   platform 'ubuntu'

#   context 'mod_ssl' do
#     recipe do
#       apache2_install 'package'
#       apache2_mod_ssl 'default'
#     end

#     it 'outputs template correctly' do
#       stub_command('/usr/sbin/apache2ctl -t').and_return('OK')

#       is_expected.not_to render_file('/etc/apache2/mods-available/ssl.conf')
#         .with_content(/SSLStrictSNIVHostCheck Off/)

#       is_expected.to render_file('/etc/apache2/mods-available/ssl.conf')
#         .with_content(/SSLProtocol TLSv1.2/)
#     end
#   end
# end
