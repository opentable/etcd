# == Class etcd0xx::config
#
class etcd0xx::config {
  case $::osfamily {
    'RedHat' : {
      file { '/etc/sysconfig/etcd':
        ensure  => present,
        owner   => $etcd0xx::user,
        group   => $etcd0xx::group,
        mode    => '0644',
        content => template('etcd/etcd.sysconfig.erb'),
      }
    }
    'Debian' : {
      file { '/etc/etcd':
        ensure => directory,
        owner  => $etcd0xx::user,
        group  => $etcd0xx::group,
        mode   => '0555'
      }

      file { '/etc/etcd/etcd.conf':
        ensure  => file,
        owner   => $etcd0xx::user,
        group   => $etcd0xx::group,
        mode    => '0644',
        content => template('etcd/etcd.conf.erb'),
        require => File['/etc/etcd']
      }
    }
    default  : {
      fail("OSFamily ${::osfamily} not supported.")
    }
  }
}
