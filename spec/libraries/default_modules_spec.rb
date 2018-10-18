require 'spec_helper'

describe '#default_modules' do
  context 'systemd' do
    automatic_attributes['init_package'] = 'systemd'

    recipe do
      log default_modules
    end

    context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd, systemd') }
    end

    context 'fedora' do
      platform 'fedora'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd, systemd') }
    end

    context 'amazon' do
      platform 'amazon'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd, systemd') }
    end

    context 'suse' do
      platform 'suse'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio') }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif') }
    end

    context 'arch' do
      platform 'arch'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end

    context 'freebsd' do
      platform 'freebsd'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end
  end

  context 'systemd' do
    automatic_attributes['init_package'] = 'sysv'

    recipe do
      log default_modules
    end

    context 'redhat' do
      platform 'redhat'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end

    context 'fedora' do
      platform 'fedora'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end

    context 'amazon' do
      platform 'amazon'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end

    context 'suse' do
      platform 'suse'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio') }
    end

    context 'debian' do
      platform 'debian'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif') }
    end

    context 'arch' do
      platform 'arch'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end

    context 'freebsd' do
      platform 'freebsd'
      it { is_expected.to write_log('status, alias, auth_basic, authn_core, authn_file, authz_core, authz_groupfile, authz_host, authz_user, autoindex, deflate, dir, env, mime, negotiation, setenvif, log_config, logio, unixd') }
    end
  end
end
