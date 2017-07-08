apt_update 'update'

case node['platform_family']
when 'debian'
  package %w(libxml2 libxml2-dev libxslt1-dev)
when 'rhel'
  package %w(gcc make ruby-devel libxml2 libxml2-devel libxslt libxslt-devel)
end

package 'curl'
