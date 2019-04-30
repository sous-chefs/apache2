apt_update 'update'

apache2_install 'default_install' do
  ports '8080'
end
