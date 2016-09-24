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
  $service_ensure          = $etcd::params::etcd_service_ensure,
  $service_enable          = $etcd::params::etcd_service_enable,
  $package_ensure          = $etcd::params::etcd_package_ensure,
  $package_name            = $etcd::params::etcd_package_name,
  $binary_location         = $etcd::params::etcd_binary_location,
  $manage_user             = $etcd::params::etcd_manage_user,
  $user                    = $etcd::params::etcd_user,
  $group                   = $etcd::params::etcd_group,
  $addr                    = $etcd::params::etcd_addr,
  $cors                    = $etcd::params::etcd_cors,
  $log_dir                 = $etcd::params::etcd_log_dir,
  $cpu_profile_file        = $etcd::params::etcd_cpu_profile_file,
  $manage_data_dir         = $etcd::params::etcd_manage_data_dir,
  $data_dir                = $etcd::params::etcd_data_dir,
  $manage_log_dir          = $etcd::params::etcd_manage_log_dir,
  $discovery               = $etcd::params::etcd_discovery,
  $discovery_endpoint      = $etcd::params::etcd_discovery_endpoint,
  $discovery_token         = $etcd::params::etcd_discovery_token,
  $node_name               = $etcd::params::etcd_node_name,
  $snapshot                = $etcd::params::etcd_snapshot,
  $snapshot_count          = $etcd::params::etcd_snapshot_count,
  $verbose                 = $etcd::params::etcd_verbose,
  $very_verbose            = $etcd::params::etcd_very_verbose,
  $peer_election_timeout   = $etcd::params::etcd_peer_election_timeout,
  $peer_heartbeat_interval = $etcd::params::etcd_peer_heartbeat_interval,
  $peer_addr               = $etcd::params::etcd_peer_addr,
  $cluster_active_size     = $etcd::params::etcd_cluster_active_state,
  $cluster_remove_delay    = $etcd::params::etcd_cluster_remove_delay,
  $cluster_sync_interval   = $etcd::params::etcd_cluster_sync_interval,
  $wal_dir                 = $etcd::params::etcd_wal_dir,
  $max_wals                = $etcd::params::etcd_max_wals,
  $quota_backend_bytes     = $etcd::params::etcd_quota_backend_bytes,
  $max_snapshots           = $etcd::params::etcd_max_snapshots,
  $initial_cluster         = $etcd::params::etcd_initial_cluster,
  $initial_cluster_token   = $etcd::params::etcd_initial_cluster_token,
  $initial_cluster_state   = $etcd::params::etcd_initial_cluster_state,
  $strict_reconfig_check   = $etcd::params::etcd_strict_reconfig_check,
  $proxy                   = $etcd::params::etcd_proxy,
  $proxy_failure_wait      = $etcd::params::etcd_proxy_failure_wait,
  $proxy_refresh_interval  = $etcd::params::etcd_proxy_refresh_interval,
  $proxy_dial_timeout      = $etcd::params::etcd_proxy_dial_timeout,
  $proxy_write_timeout     = $etcd::params::etcd_proxy_write_timeout,
  $proxy_read_timeout      = $etcd::params::etcd_proxy_read_timeout,
  $client_security         = $etcd::params::etcd_client_security,
  $client_ca_file          = $etcd::params::etcd_client_ca_file,
  $client_cert_file        = $etcd::params::etcd_client_cert_file,
  $client_key_file         = $etcd::params::etcd_client_key_file,
  $client_cert_auth        = $etcd::params::etcd_client_cert_auth,
  $client_trusted_ca_file  = $etcd::params::etcd_client_trusted_ca_file,
  $client_auto_tls         = $etcd::params::etcd_client_auto_tls,
  $peer_security           = $etcd::params::etcd_peer_security,
  $peer_ca_file            = $etcd::params::etcd_peer_ca_file,
  $peer_cert_file          = $etcd::params::etcd_peer_cert_file,
  $peer_key_file           = $etcd::params::etcd_peer_key_file,
  $peer_cert_auth          = $etcd::params::etcd_peer_cert_auth,
  $peer_trusted_ca_file    = $etcd::params::etcd_peer_trusted_ca_file,
  $peer_auto_tls           = $etcd::params::etcd_peet_auto_tls,
  $debug                   = $etcd::params::etcd_debug,
  $log_package_levels      = $etcd::params::etcd_log_package_levels,
  $force_new_cluster       = $etcd::params::etcd_force_new_cluster) inherits etcd::params {


  # Discovery settings
  validate_bool($discovery)
  # If not using discovery, should have a valid list of peers
  if (!$discovery) {
    validate_array($initial_cluster)
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

  anchor { 'etcd::begin': } ->
  class { '::etcd::install': } ->
  class { '::etcd::config': } ~>
  class { '::etcd::service': } ->
  anchor { 'etcd::end': }

}
