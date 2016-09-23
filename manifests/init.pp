# == Class: etcd0xx
#
# Installs and configures etcd.
#
# === Parameters
#
# === Examples
#
#  class { etcd0xx: }
#
# === Authors
#
# Kyle Anderson <kyle@xkyle.com>
# Mathew Finch <finchster@gmail.com>
# Gavin Williams <fatmcgav@gmail.com>
#
class etcd0xx (
  $service_ensure          = $etcd0xx::params::etcd_service_ensure,
  $service_enable          = $etcd0xx::params::etcd_service_enable,
  $package_ensure          = $etcd0xx::params::etcd_package_ensure,
  $package_name            = $etcd0xx::params::etcd_package_name,
  $binary_location         = $etcd0xx::params::etcd_binary_location,
  $manage_user             = $etcd0xx::params::etcd_manage_user,
  $user                    = $etcd0xx::params::etcd_user,
  $group                   = $etcd0xx::params::etcd_group,
  $addr                    = $etcd0xx::params::etcd_addr,
  $cors                    = $etcd0xx::params::etcd_cors,
  $cpu_profile_file        = $etcd0xx::params::etcd_cpu_profile_file,
  $manage_data_dir         = $etcd0xx::params::etcd_manage_data_dir,
  $data_dir                = $etcd0xx::params::etcd_data_dir,
  $manage_log_dir          = $etcd0xx::params::etcd_manage_log_dir,
  $discovery               = $etcd0xx::params::etcd_discovery,
  $discovery_endpoint      = $etcd0xx::params::etcd_discovery_endpoint,
  $discovery_token         = $etcd0xx::params::etcd_discovery_token,
  $node_name               = $etcd0xx::params::etcd_node_name,
  $snapshot                = $etcd0xx::params::etcd_snapshot,
  $snapshot_count          = $etcd0xx::params::etcd_snapshot_count,
  $verbose                 = $etcd0xx::params::etcd_verbose,
  $very_verbose            = $etcd0xx::params::etcd_very_verbose,
  $peer_election_timeout   = $etcd0xx::params::etcd_peer_election_timeout,
  $peer_heartbeat_interval = $etcd0xx::params::etcd_peer_heartbeat_interval,
  $peer_addr               = $etcd0xx::params::etcd_peer_addr,
  $cluster_active_size     = $etcd0xx::params::etcd_cluster_active_state,
  $cluster_remove_delay    = $etcd0xx::params::etcd_cluster_remove_delay,
  $cluster_sync_interval   = $etcd0xx::params::etcd_cluster_sync_interval,
  $wal_dir                 = $etcd0xx::params::etcd_wal_dir,
  $max_wals                = $etcd0xx::params::etcd_max_wals,
  $quota_backend_bytes     = $etcd0xx::params::etcd_quota_backend_bytes,
  $max_snapshots           = $etcd0xx::params::etcd_max_snapshots,
  $initial_cluster         = $etcd0xx::params::etcd_initial_cluster,
  $initial_cluster_token   = $etcd0xx::params::etcd_initial_cluster_token,
  $initial_cluster_state   = $etcd0xx::params::etcd_initial-cluster_state,
  $strict_reconfig_check   = $etcd0xx::params::etcd_strict_reconfig_check,
  $proxy                   = $etcd0xx::params::etcd_proxy,
  $proxy_failure_wait      = $etcd0xx::params::etcd_proxy_failure_wait,
  $proxy_refresh_interval  = $etcd0xx::params::etcd_proxy_refresh_interval,
  $proxy_dial_timeout      = $etcd0xx::params::etcd_proxy_dial_timeout,
  $proxy_write_timeout     = $etcd0xx::params::etcd_proxy_write_timeout,
  $proxy_read_timeout      = $etcd0xx::params::etcd_proxy_read_timeout,
  $client_security         = $etcd0xx::params::etcd_client_security,
  $client_ca_file          = $etcd0xx::params::etcd_client_ca_file,
  $client_cert_file        = $etcd0xx::params::etcd_client_cert_file,
  $client_key_file         = $etcd0xx::params::etcd_client_key_file,
  $client_cert_auth        = $etcd0xx::params::etcd_client_cert_auth,
  $client_trusted_ca_file  = $etcd0xx::params::etcd_client_trusted_ca_file,
  $client_auto_tls         = $etcd0xx::params::etcd_client_auto_tls,
  $peer_security           = $etcd0xx::params::etcd_peer_security,
  $peer_ca_file            = $etcd0xx::params::etcd_peer_ca_file,
  $peer_cert_file          = $etcd0xx::params::etcd_peer_cert_file,
  $peer_key_file           = $etcd0xx::params::etcd_peer_key_file,
  $peer_cert_auth          = $etcd0xx::params::etcd_peer_cert_auth,
  $peer_trusted_ca_file    = $etcd0xx::params::etcd_peer_trusted_ca_file,
  $peer_auto_tls           = $etcd0xx::params::etcd_peet_auto_tls,
  $debug                   = $etcd0xx::params::etcd_debug,
  $log_package_levels      = $etcd0xx::params::etcd_log_package_levels,
  $force_new_cluster       = $etcd0xx::params::etcd_force_new_cluster) inherits etcd0xx::params {

  # Discovery settings
  validate_bool($discovery)
  # If not using discovery, should have a valid list of peers
  if (!$discovery) {
    validate_array($peers)
  }
  # If using discovery, should have a valid discovery token
  if ($discovery and $discovery_token == '') {
    fail('Invalid discovery token specified')
  }

  # Validate other params
  validate_array($cors)
  validate_bool($manage_user)
  validate_bool($snapshot)
  validate_bool($verbose)
  validate_bool($very_verbose)
  validate_bool($manage_data_dir)

  anchor { 'etcd0xx::begin': } ->
  class { '::etcd0xx::install': } ->
  class { '::etcd0xx::config': } ~>
  class { '::etcd0xx::service': } ->
  anchor { 'etcd0xx::end': }

}
