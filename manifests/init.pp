# NRPE installation and configuration for
# Nagios monitoring
#
class nrpe {
  include nrpe::install, nrpe::services, nrpe::user
}
