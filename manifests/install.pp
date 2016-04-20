# == Class etcd0xx::install
#
class etcd0xx::install {
  # Create group and user if required
  if $etcd0xx::manage_user {
    group { $etcd0xx::group: ensure => 'present' }

    user { $etcd0xx::user:
      ensure  => 'present',
      gid     => $etcd0xx::group,
      require => Group[$etcd0xx::group],
      before  => Package['etcd']
    }
  }

  # Create etcd data dir if required
  if $etcd0xx::manage_data_dir {
    file { $etcd0xx::data_dir:
      ensure => 'directory',
      owner  => $etcd0xx::user,
      group  => $etcd0xx::group,
      mode   => '0750',
      before => Package['etcd']
    }
  }

  # Create etcd log dir if required
  if $etcd0xx::manage_log_dir {
    file { $etcd0xx::log_dir:
      ensure => 'directory',
      owner  => $etcd0xx::user,
      group  => $etcd0xx::group,
      mode   => '0750',
      before => Package['etcd']
    }
  }

  # Setup resource ordering if appropriate
  if ($etcd0xx::manage_user and $etcd0xx::manage_data_dir) {
    User[$etcd0xx::user] -> File[$etcd0xx::data_dir]
  }
  if ($etcd0xx::manage_user and $etcd0xx::manage_log_dir) {
    User[$etcd0xx::user] -> File[$etcd0xx::log_dir]
  }

  # Install the required package
  package { 'etcd':
    ensure => $etcd0xx::package_ensure,
    name   => $etcd0xx::package_name,
  }
}
