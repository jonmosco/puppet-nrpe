# update /etc/services 
# 
# No easy way to update without doing a full copy
#
#
class nrpe::services {
  file { 'services':
    ensure => file,
    path   => '/etc/services',
    source => 'puppet:///modules/nrpe/services',
    requre => Class['nrpe::install'],
  }
}
