if platform?("debian", "ubuntu")
  remote_file "/tmp/mod-pagespeed.deb" do
    source "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb"
    mode 0644
    action :create_if_missing
  end

  dpkg_package "mod_pagespeed" do
    source "/tmp/mod-pagespeed.deb"
    action :install
  end
  
  apache_module "pagespeed" do
    conf true
  end
end
