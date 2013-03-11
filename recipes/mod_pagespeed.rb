if platform?("debian", "ubuntu")
  remote_file "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb" do
    source "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb"
    mode 0644
    action :create_if_missing
  end

  dpkg_package "mod_pagespeed" do
    source "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb"
    action :install
  end
  
  apache_module "pagespeed" do
    conf true
  end
end
