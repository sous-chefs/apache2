
describe '#mpm_support' do
  recipe do
    log default_mpm
  end

  context 'redhat' do
    platform 'redhat'
    it { is_expected.to write_log('prefork') }
  end

  context 'fedora' do
    platform 'redhat'
    it { is_expected.to write_log('prefork') }
  end

  context 'amazon' do
    platform 'amazon'
    it { is_expected.to write_log('prefork') }
  end

  context 'suse' do
    platform 'suse'
    it { is_expected.to write_log('prefork') }
  end

  context 'debian' do
    platform 'debian'
    it { is_expected.to write_log('worker') }
  end

  context 'arch' do
    platform 'arch'
    it { is_expected.to write_log('prefork') }
  end

  context 'freebsd' do
    platform 'freebsd'
    it { is_expected.to write_log('prefork') }
  end

  context 'linuxmint' do
    platform 'linuxmint'
    it { is_expected.to write_log('event') }
  end

  context 'ubuntu' do
    platform 'ubuntu'
    it { is_expected.to write_log('event') }
  end
end
