require 'json'

def load_platform_properties(args)
  JSON.parse(IO.read(File.join(File.dirname(__FILE__), "/../../test/integration/default/files/platforms/#{args[:platform]}/#{args[:platform_version]}.json")), symbolize_names: true)
end
