class A2Helper < Inspec.resource(1)
  name 'apache_info'

  def initialize(platform_path)
    filename = "%{platform}/%{release}.json" % { :platform => inspec.os.name, :release => inspec.os.release }
    # TODO: the platform path stuff should also work from here
    # platform_path = File.expand_path File.join(File.dirname(__FILE__), '..', 'libraries', 'platforms')
    path = File.join(platform_path, filename )
    @params = JSON.parse(IO.read(path), :symbolize_names => true)
  end

  def [](name)
    @params[name]
  end
end
