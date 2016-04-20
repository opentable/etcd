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
  $bind_addr               = $etcd0xx::params::etcd_bind_addr,
  $ca_file                 = $etcd0xx::params::etcd_ca_file,
  $cert_file               = $etcd0xx::params::etcd_cert_file,
  $key_file                = $etcd0xx::params::etcd_key_file,
  $cors                    = $etcd0xx::params::etcd_cors,
  $cpu_profile_file        = $etcd0xx::params::etcd_cpu_profile_file,
  $manage_data_dir         = $etcd0xx::params::etcd_manage_data_dir,
  $data_dir                = $etcd0xx::params::etcd_data_dir,
  $manage_log_dir          = $etcd0xx::params::etcd_manage_log_dir,
  $log_dir                 = $etcd0xx::params::etcd_log_dir,
  $discovery               = $etcd0xx::params::etcd_discovery,
  $discovery_endpoint      = $etcd0xx::params::etcd_discovery_endpoint,
  $discovery_token         = $etcd0xx::params::etcd_discovery_token,
  $peers                   = $etcd0xx::params::etcd_peers,
  $peers_file              = $etcd0xx::params::etcd_peers_file,
  $max_result_buffer       = $etcd0xx::params::etcd_max_result_buffer,
  $max_retry_attempts      = $etcd0xx::params::etcd_max_retry_attempts,
  $node_name               = $etcd0xx::params::etcd_node_name,
  $snapshot                = $etcd0xx::params::etcd_snapshot,
  $snapshot_count          = $etcd0xx::params::etcd_snapshot_count,
  $verbose                 = $etcd0xx::params::etcd_verbose,
  $very_verbose            = $etcd0xx::params::etcd_very_verbose,
  $peer_election_timeout   = $etcd0xx::params::etcd_peer_election_timeout,
  $peer_heartbeat_interval = $etcd0xx::params::etcd_peer_heartbeat_interval,
  $peer_addr               = $etcd0xx::params::etcd_peer_addr,
  $peer_bind_addr          = $etcd0xx::params::etcd_peer_bind_addr,
  $peer_ca_file            = $etcd0xx::params::etcd_peer_ca_file,
  $peer_cert_File          = $etcd0xx::params::etcd_peer_cert_File,
  $peer_key_file           = $etcd::params::etcd_peer_key_file,
  $cluster_active_size     = $etcd::params::etcd_cluster_active_state,
  $cluster_remove_delay    = $etcd::params::etcd_cluster_remove_delay,
  $cluster_sync_interval   = $etcd::params::etcd_cluster_sync_interval) inherits etcd::params {

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
