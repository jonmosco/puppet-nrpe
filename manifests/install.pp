# Very Early manifest to install NRPE on EL
# servers for Nagios monitoring
#
# TODO
# - Way to much to list right now
# - Make Available for Debian
#
# Possible Order of operations:
# - Make sure xinetd is installed
#   - Dependency from base module needes to be required [DONE 2/27/13]
# - Create nagios user and group [DONE 2/25/13]
# - Install Nagios Plugins
#   - Need to create RPM for plugins [DONE]
# - Install NRPE
# - Copy /etc/services [DONE 2/27/13]
#   NOTE: should this be a base file?
# - Configure xinetd [DONE 2/27/13]
# - Restart xinetd [DONE 2/27/13]
# - Move plugin install to this manifest [DONE 3/7/13]
# - Restart xinetd at the proper time [DONE 3/8/13]
# - Move RPM to a local repository
#
class nrpe::install {
  if $::osfamily == 'RedHat' {

    package { 'nagios-plugins-1.4.16-1.x86_64':
      ensure   => present,
      provider => rpm,
      source   => 'http://puppet/nagios-plugins-1.4.16-1.x86_64.rpm',
      require  => Class['rhelbase'],
    }

    file { '/usr/local/nagios':
      owner   => 'nagios',
      group   => 'nagios',
      require => Package['nagios-plugins-1.4.16-1.x86_64'],
    }

    file { '/usr/local/nagios/libexec':
      recurse => true,
      owner   => 'nagios',
      group   => 'nagios',
      require => Package['nagios-plugins-1.4.16-1.x86_64'],
    }

    file { 'check_nrpe':
      path    => '/usr/local/nagios/libexec/check_nrpe',
      source  => 'puppet:///modules/nrpe/check_nrpe',
      owner   => 'nagios',
      group   => 'nagios',
      mode    => '0775',
      require => Package['nagios-plugins-1.4.16-1.x86_64'],
    }

    file { '/usr/local/nagios/etc':
      ensure => directory,
      owner  => 'nagios',
      group  => 'nagios',
    }

    file { '/usr/local/nagios/bin':
      ensure => directory,
      owner  => 'nagios',
      group  => 'nagios',
    }

    file { 'nrpe_daemon':
      path    => '/usr/local/nagios/bin/nrpe',
      source  => 'puppet:///modules/nrpe/nrpe',
      owner   => 'nagios',
      group   => 'nagios',
      mode    => '0775',
    }

    file { 'nrpe.cfg':
      path    => '/usr/local/nagios/etc/nrpe.cfg',
      owner   => 'nagios',
      group   => 'nagios',
      mode    => '0644',
      content => template('nrpe/nrpe.erb'),
    }

    file { 'services':
      path   => '/etc/services',
      source => 'puppet:///modules/nrpe/services',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    file { 'nrpe':
      path      => '/etc/xinetd.d/nrpe',
      source    => 'puppet:///modules/nrpe/nrpe_xinetd',
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      require   => Class['rhelbase::install'],
      subscribe => File['nrpe.cfg'],
    }

    service { 'xinetd':
      ensure    => running,
      enable    => true,
      require   => Class['rhelbase::install'],
      subscribe => File['nrpe'],
    }

  }
}
