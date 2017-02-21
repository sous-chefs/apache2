class A2Helper < Inspec.resource(1)
  name 'apache_info'

  # TODO: temporary we use the controls_dir until
  # https://github.com/chef/inspec/issues/1396 is resolved
  def initialize(controls_dir)
    platform_path = File.expand_path File.join(controls_dir, '..', 'files', 'platforms')
    filename = '%{platform}/%{release}.json' % { platform: inspec.os.name, release: inspec.os.release }
    path = File.join(platform_path, filename)
    @params = JSON.parse(IO.read(path), symbolize_names: true)
  end

  def [](name)
    @params[name]
  end
end
