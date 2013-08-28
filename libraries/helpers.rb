module Apache
  module Helpers
    def generate_bash_command_line(command)
      return command unless platform?('windows')
      # Chef installs MinGW on Windows, which provides an implementation of bash
      "bash #{command}".gsub('/', '\\')
    end
  end
end
