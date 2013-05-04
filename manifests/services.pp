# update /etc/services to all monitored hosts to include
# NRPE

class nrpe::services {
  file { 'services':
    ensure => file,
    path   => '/etc/services',
    source => 'puppet:///modules/nrpe/services',
    requre => Class['nrpe::install'],
  }
}
