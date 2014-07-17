require_relative '../../../kitchen/data/spec_helper'

property[:apache][:default_modules].each do |expected_module|
  describe "apache2::mod_#{expected_module}" do
    describe file("#{property[:apache][:dir]}/mods-available/#{expected_module}.load") do
      it { should be_file }
      it { should be_mode 644 }
      its(:content) { should match "LoadModule #{expected_module}_module #{property[:apache][:libexec_dir]}/mod_#{expected_module}.so\n" }
    end
    describe file("#{property[:apache][:dir]}/mods-enabled/#{expected_module}.load") do
      it { should be_linked_to "#{property[:apache][:dir]}/mods-available/#{expected_module}.load" }
    end

    describe command("#{property[:apache][:binary]} -M") do
      it { should return_exit_status 0 }
      it { should return_stdout /#{expected_module}_module/ }
    end
  end
end
