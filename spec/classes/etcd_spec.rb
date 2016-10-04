require 'spec_helper'

describe 'etcd', :type => :class do
  describe 'On an unknown OS' do
    let(:facts) { {:osfamily => 'Unknown'} }
    it { should raise_error() }
  end

  describe 'On a Debian OS' do
    let(:facts) { {
        :osfamily => 'Debian',
        :fqdn     => 'etcd.test.local'
      } }

    context 'With defaults' do
      # Default etcd conf file
      let(:etcd_default_config) {
        File.read(my_fixture("etcd.conf.yml"))
      }

      # Default upstart file
      let(:etcd_default_upstart) {
        File.read(my_fixture("etcd.upstart"))
      }

      # etcd::init resources
      it { should create_class('etcd') }
      it { should contain_class('etcd::params') }
      it { should contain_anchor('etcd::begin') }
      it { should create_class('etcd::install').that_requires('Anchor[etcd::begin]')}
      it { should create_class('etcd::config').that_requires('Class[etcd::install]').that_notifies('Class[etcd::service]')}
      it { should create_class('etcd::service').that_comes_before('Anchor[etcd::end]')}
      it { should contain_anchor('etcd::end') }
      # etcd::install resources
      it { should contain_group('etcd').with_ensure('present') }
      it { should contain_user('etcd').with_ensure('present').with_gid('etcd').that_requires('Group[etcd]') }
      it { should contain_file('/var/lib/etcd').with({
          'ensure' =>'directory',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0750'
        }).that_requires('User[etcd]').that_comes_before('Package[etcd]') }
      it { should contain_file('/var/log/etcd').with({
          'ensure' =>'directory',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0750'
        }).that_requires('User[etcd]').that_comes_before('Package[etcd]') }
      it { should contain_package('etcd').with_ensure('installed')}
      # etcd::config resources
      it { should contain_file('/etc/etcd').with({
          'ensure' => 'directory',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0555'
        }) }
      it { should contain_file('/etc/etcd/etcd.conf.yml').with({
          'ensure' => 'file',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0644'
        }).with_content(etcd_default_config).that_requires('File[/etc/etcd]') }
      # etcd::service resources
      it { should contain_file('etcd-servicefile').with({
      'ensure' => 'file',
      'path'   => '/etc/init.d/etcd',
      'owner'  => 'etcd',
      'group'  => 'etcd',
      'mode'   => '0755'
      }).that_notifies('Service[etcd]') }
      it { should contain_service('etcd').only_with( {
          'ensure'   => 'running',
          'enable'   => 'true',
          'provider' => nil
      } ) }

      end

    context 'When overriding service parameters' do
      let(:params) { {
          :service_ensure => 'stopped',
          :service_enable => false
        } }
      it { should contain_service('etcd').with_ensure('stopped').with_enable('false') }
    end

    context 'When overriding package parameters' do
      let(:params) { {
          :package_ensure => 'absent',
          :package_name   => 'custom_etcd' }}
      it { should contain_package('etcd').with(
        'name'   => 'custom_etcd',
        'ensure' => 'absent'
        ) }
    end

    context 'When asked not to manage the user' do
      let(:params) { {:manage_user => false } }
      it {
        should_not contain_group('etcd')
        should_not contain_user('etcd')
      }
    end

    context 'When using a custom data directory' do
      let(:params) { { :data_dir => '/custom/dne' } }
      it { should contain_file('/custom/dne').with({
          'ensure' => 'directory',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0750'
        }).that_requires('User[etcd]').that_comes_before('Package[etcd]') }
      it { should contain_file('/etc/etcd/etcd.conf.yml').with_content(/data-dir: '\/custom\/dne'/) }
    end

    context 'When using a custom log directory' do
      let(:params) { { :log_dir => '/loghere/etcd' } }
      it { should contain_file('/loghere/etcd').with({
          'ensure' => 'directory',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0750'
        }).that_requires('User[etcd]').that_comes_before('Package[etcd]') }
      it { should contain_file('etcd-servicefile').with_content(/\/loghere\/etcd\/etcd.out/) }
    end

    context 'When specifying a custom discovery endpoint' do
      let(:params) { {
          :discovery          => true,
          :discovery_endpoint => 'http://local-discovery:4001/v2/keys/',
        } }
      it {
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/discovery: 'http:\/\/local-discovery:4001\/v2\/keys\/'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/discovery-fallback: 'proxy'/)
      }
    end

    context 'When specifying all of the etcd config params' do
      let(:params) { {
          :listen_client_urls           => 'http://localhost:2379,http://localhost:4001',
          :listen_peer_urls             => 'http://localhost:2380,http://localhost:7001',
          :initial_advertise_peer_urls  => 'http://localhost:2380,http://localhost:7001',
          :advertise_client_urls        => 'http://localhost:2379,http://localhost:4001',
          :initial_cluster              => 'test_node_name=http://localhost:2380,test_node_name=http://localhost:7001',
          :initial_cluster_token        => '12345',
          :initial_cluster_state        => 'old',
          :strict_reconfig_check        => true,
          :proxy                        => 'on',
          :proxy_failure_wait           => '2500',
          :proxy_refresh_interval       => '3000',
          :proxy_dial_timeout           => '1500',
          :proxy_write_timeout          => '6000',
          :proxy_read_timeout           => '6000',
          :peer_security                => true,
          :wal_dir                      => '/test/wal',
          :max_wals                     => '5',
          :binary_location              => '/bin/etcd',
          :cors                         => 'cors1,cors2',
          :data_dir                     => '/test/data_dir',
          :group                        => 'etcd_group',
          :log_dir                      => '/test/log_dir',
          :node_name                    => 'test_node_name',
          :snapshot                     => true,
          :snapshot_count               => '10000',
          :max_snapshots                => '20000',
          :user                         => 'etcd_user',
          :election_timeout             => '400',
          :heartbeat_interval           => '60',
          :debug                        => true,
          :log_package_levels           => 'DEBUG',
          :force_new_cluster            => true

        } }
      it { should contain_group('etcd_group').with_ensure('present') }
      it { should contain_user('etcd_user').with_ensure('present').with_gid('etcd_group').that_requires('Group[etcd_group]') }
      it { should contain_file('/test/data_dir').with({
          'ensure' =>'directory',
          'owner'  => 'etcd_user',
          'group'  => 'etcd_group',
          'mode'   => '0750'
        }).that_requires('User[etcd_user]').that_comes_before('Package[etcd]') }
      it { should contain_file('/test/log_dir').with({
          'ensure' =>'directory',
          'owner'  => 'etcd_user',
          'group'  => 'etcd_group',
          'mode'   => '0750'
        }).that_requires('User[etcd_user]').that_comes_before('Package[etcd]') }
      it {
        # Ensure that the config file is correctly populated
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/listen-client-urls: 'http:\/\/localhost:2379,http:\/\/localhost:4001'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/listen-peer-urls: 'http:\/\/localhost:2380,http:\/\/localhost:7001'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/initial-advertise-peer-urls: 'http:\/\/localhost:2380,http:\/\/localhost:7001'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/advertise-peer-urls: 'http:\/\/localhost:2380,http:\/\/localhost:7001'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/initial-cluster: 'test_node_name=http:\/\/localhost:2380,test_node_name=http:\/\/localhost:7001'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/initial-cluster-token: '12345'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/initial-cluster-state: 'old'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/strict-reconfig-check: true/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/proxy: 'on'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/proxy-failure-wait: 2500/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/proxy-refresh-interval: 3000/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/proxy-dial-timeout: 1500/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/proxy-write-timeout: 6000/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/proxy-read-timeout: 6000/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/wal-dir: '\/test\/wal'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/max-wals: 5/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/cors: 'cors1,cors2'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/data-dir: '\/test\/data_dir'/)
        should contain_file('/etc/etcd/etcd.conf.yml').without_content(/discovery:/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/name: 'test_node_name'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/snapshot-count: 10000/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/max-snapshots: 20000/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/election-timeout: 400/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/heartbeat-interval: 60/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/debug: true/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/log-package-levels: 'DEBUG'/)
        should contain_file('/etc/etcd/etcd.conf.yml').with_content(/force-new-cluster: true/)
      }
      it {
        # Ensure that the upstart script is correctly populated
        should contain_file('etcd-servicefile').with_content(/\/bin\/etcd/)
        should contain_file('etcd-servicefile').with_content(/\/test\/log_dir\/etcd.out/)
      }
    end
  end
end
