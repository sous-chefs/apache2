if platform?("debian", "ubuntu")
  remote_file "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb" do
    source node["apache2"]["mod_pagespeed"]["package_link"]
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
else
  Chef::Log.warm "apache::mod_pagespeed does not support #{node["platform"]} yet, and is not being installed"
end
