# NRPE user
#
class nrpe::user {
  group { 'nagios':
    ensure => present,
    gid    => '501',
  }
  user { 'nagios':
    ensure => present,
    uid    => '501',
    gid    => 'nagios',
    shell  => '/sbin/nologin',
  }
}
