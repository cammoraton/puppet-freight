# Class: freight::apache
#
# This class wraps around and configures apache
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class freight::apache (
  $default_vhost     = false,
  $ssl               = false,
  $http_port         = '80',
  $https_port        = '443',
  $docroot           = $::apache::docroot,
  $servername        = $freight::servername
) {
  if $default_vhost {
    class { '::apache':
      default_vhost     => false,
      default_ssl_vhost => false
    }
  } else {
    include apache
  }

  apache::vhost { 'freight':
    port              => $http_port,
    servername        => $servername,
    docroot           => $docroot,
    default_vhost     => $default_vhost
  }

  if $ssl {
    include apache::mod::ssl
    apache::vhost { 'freight-ssl':
      port            => $https_port,
      servername      => $servername,
      ssl             => true,
      docroot         => $docroot,
      default_vhost   => $default_vhost
    }
  }
}