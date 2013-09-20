apt_repository "cloudflare" do
  uri "http://pkg.cloudflare.com"
  distribution node['lsb']['codename']
  components ["main"]
  key "http://pkg.cloudflare.com/pubkey.gpg"
  action :add
end

package "libapache2-mod-cloudflare" do
  notifies :restart, "service[apache2]"
end
