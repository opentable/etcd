# == Class: etcd
#
# Installs and configures etcd.
#
# === Parameters
#
# === Examples
#
#  class { etcd: }
#
# === Authors
#
# Kyle Anderson <kyle@xkyle.com>
# Mathew Finch <finchster@gmail.com>
# Gavin Williams <fatmcgav@gmail.com>
#
class etcd (
  $service_ensure              = $etcd::params::etcd_service_ensure,
  $service_enable              = $etcd::params::etcd_service_enable,
  $package_ensure              = $etcd::params::etcd_package_ensure,
  $package_name                = $etcd::params::etcd_package_name,
  $binary_location             = $etcd::params::etcd_binary_location,
  $manage_user                 = $etcd::params::etcd_manage_user,
  $user                        = $etcd::params::etcd_user,
  $group                       = $etcd::params::etcd_group,
  $cors                        = $etcd::params::etcd_cors,
  $manage_log_dir              = $etcd::params::etcd_manage_log_dir,
  $log_dir                     = $etcd::params::etcd_log_dir,
  $node_name                   = $etcd::params::etcd_node_name,
  $manage_data_dir             = $etcd::params::etcd_manage_data_dir,
  $data_dir                    = $etcd::params::etcd_data_dir,
  $listen_client_urls          = $etcd::params::etcd_listen_client_urls,
  $discovery                   = $etcd::params::etcd_discovery,
  $discovery_endpoint          = $etcd::params::etcd_discovery_endpoint,
  $snapshot                    = $etcd::params::etcd_snapshot,
  $snapshot_count              = $etcd::params::etcd_snapshot_count,
  $election_timeout            = $etcd::params::etcd_election_timeout,
  $heartbeat_interval          = $etcd::params::etcd_heartbeat_interval,
  $listen_peer_urls            = $etcd::params::etcd_listen_peer_urls,
  $wal_dir                     = $etcd::params::etcd_wal_dir,
  $max_wals                    = $etcd::params::etcd_max_wals,
  $max_snapshots               = $etcd::params::etcd_max_snapshots,
  $initial_advertise_peer_urls = $etcd::params::etcd_initial_advertise_peer_urls,
  $advertise_client_urls       = $etcd::params::etcd_advertise_client_urls,
  $initial_cluster             = $etcd::params::etcd_initial_cluster,
  $initial_cluster_token       = $etcd::params::etcd_initial_cluster_token,
  $initial_cluster_state       = $etcd::params::etcd_initial_cluster_state,
  $strict_reconfig_check       = $etcd::params::etcd_strict_reconfig_check,
  $proxy                       = $etcd::params::etcd_proxy,
  $proxy_failure_wait          = $etcd::params::etcd_proxy_failure_wait,
  $proxy_refresh_interval      = $etcd::params::etcd_proxy_refresh_interval,
  $proxy_dial_timeout          = $etcd::params::etcd_proxy_dial_timeout,
  $proxy_write_timeout         = $etcd::params::etcd_proxy_write_timeout,
  $proxy_read_timeout          = $etcd::params::etcd_proxy_read_timeout,
  $client_security             = $etcd::params::etcd_client_security,
  $client_cert_file            = $etcd::params::etcd_client_cert_file,
  $client_key_file             = $etcd::params::etcd_client_key_file,
  $client_cert_auth            = $etcd::params::etcd_client_cert_auth,
  $client_trusted_ca_file      = $etcd::params::etcd_client_trusted_ca_file,
  $peer_security               = $etcd::params::etcd_peer_security,
  $peer_cert_file              = $etcd::params::etcd_peer_cert_file,
  $peer_key_file               = $etcd::params::etcd_peer_key_file,
  $peer_cert_auth              = $etcd::params::etcd_peer_cert_auth,
  $peer_trusted_ca_file        = $etcd::params::etcd_peer_trusted_ca_file,
  $debug                       = $etcd::params::etcd_debug,
  $log_package_levels          = $etcd::params::etcd_log_package_levels,
  $force_new_cluster           = $etcd::params::etcd_force_new_cluster) inherits etcd::params {

  # Discovery settings
  validate_bool($discovery)
  # If not using discovery, should have a valid list of peers
  if (!$discovery and empty($initial_cluster)) {
    fail('Invalid initial cluster')
  }

  # Validate other params
  validate_bool($manage_user)
  validate_bool($snapshot)
  validate_bool($manage_data_dir)
  validate_bool($strict_reconfig_check)
  validate_bool($client_security)
  validate_bool($peer_security)
  validate_bool($debug)
  validate_bool($force_new_cluster)

  anchor { 'etcd::begin': } ->
  class { '::etcd::install': } ->
  class { '::etcd::config': } ~>
  class { '::etcd::service': } ->
  anchor { 'etcd::end': }

}
