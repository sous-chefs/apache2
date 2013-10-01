default["apache2"]["mod_pagespeed"]["package_link"] =
  if node['kernel']['machine'] =~ /^i[36']86$/
    "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_i386.deb"
  else
    "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb"
  end
