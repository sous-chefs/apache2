module Apache
  module Helpers
    def generate_bash_command_line(command)
      return command unless platform?('windows')
      "bash #{command}".gsub('/', '\\')
    end
  end
end
