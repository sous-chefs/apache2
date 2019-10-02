apt_update 'update'

apache2_install 'default_install' do
  listen '8080'
end
