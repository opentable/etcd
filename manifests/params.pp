# == Class etcd::params
#
class etcd::params {
  # Handle OS Specific config values
  case $::osfamily {
    'Debian' : { $etcd_binary_location = '/usr/sbin/etcd' }
    default  : { fail("Unsupported osfamily ${::osfamily}") }
  }

  # Service settings
  $etcd_service_ensure              = 'running'
  $etcd_service_enable              = true

  # Package settings
  $etcd_package_ensure              = 'installed'
  $etcd_package_name                = 'etcd'

  # User settings
  $etcd_manage_user                 = true
  $etcd_user                        = 'etcd'
  $etcd_group                       = 'etcd'

  # Manage Data Dir?
  $etcd_manage_data_dir             = true
  $etcd_data_dir                    = '/var/lib/etcd'

  # Manage Log Dir?
  $etcd_manage_log_dir              = true
  $etcd_log_dir                     = '/var/log/etcd'

  # Node settings
  $etcd_node_name                   = $::fqdn
  $etcd_cors                        = []

  # Discovery support
  $etcd_discovery                   = false
  $etcd_discovery_endpoint          = 'https://discovery.etcd.io/'

  #Member
  $etcd_heartbeat_interval          = '100'
  $etcd_election_timeout            = '1000'

  # Peer settings
  $etcd_listen_peer_urls            = join(["${::fqdn}:7001","${::fqdn}:2380"],",")

  # Snapshot settings
  $etcd_snapshot                    = true
  $etcd_snapshot_count              = '10000'

  $etcd_wal_dir                     = ''
  $etcd_max_wals                    = '5'
  $etcd_max_snapshots               = '5'
  $etcd_strict_reconfig_check       = false

  $etcd_listen_client_urls          = join(["${::fqdn}:2379", "${::fqdn}:4001"],",")
  $etcd_initial_advertise_peer_urls = join(["${::fqdn}:2380", "${::fqdn}:7001"],",")
  $etcd_advertise_client_urls       = join(["${::fqdn}:2380", "${::fqdn}:7001"],",")

  $etcd_initial_cluster             = join(["$::fqdn=${::fqdn}:7001","$::fqdn=${::fqdn}:2380"],",")
  $etcd_initial_cluster_token       = 'etcd-cluster'
  $etcd_initial_cluster_state       = 'new'

  $etcd_proxy                       = 'off'
  $etcd_proxy_failure_wait          = 5000
  $etcd_proxy_refresh_interval      = 30000
  $etcd_proxy_dial_timeout          = 1000
  $etcd_proxy_write_timeout         = 5000
  $etcd_proxy_read_timeout          = 0

  $etcd_client_security             = false
  $etcd_client_cert_file            = ''
  $etcd_client_key_file             = ''
  $etcd_client_cert_auth            = false
  $etcd_client_trusted_ca_file      = ''

  $etcd_peer_security               = false
  $etcd_peer_cert_file              = ''
  $etcd_peer_key_file               = ''
  $etcd_peer_cert_auth              = false
  $etcd_peer_trusted_ca_file        = ''

  $etcd_debug                       = false
  $etcd_log_package_levels          = ''
  $etcd_force_new_cluster           = false
}
