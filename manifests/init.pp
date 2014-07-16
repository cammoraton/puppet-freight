# Class: freight
#
# This module manages freight
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class freight (
  $version         = 'installed',
  $servername      = $freight::params::servername,
  $conf_file       = $freight::params::conf_file,
  $varcache        = $freight::params::varcache,
  $varlib          = $freight::params::varlib,
  $origin          = $freight::params::origin,
  $cache           = $freight::params::cache,
  $symlinks        = $freight::params::symlinks,
  $gpg_email       = $freight::params::gpg_email,
  $gpg_fullname    = $freight::params::gpg_fullname,
  $gpg_type        = $freight::params::gpg_type,
  $gpg_bits        = $freight::params::gpg_bits,
  $lazy_gpg        = true,
  $manage_apt      = true,
  $apt_label       = $freight::params::apt_label,
  $apt_key         = $freight::params::key,
  $apt_include_src = false,
  $apt_ksource     = $freight::params::key_source,
  $apt_location    = $freight::params::apt_location,
  $apt_release     = $freight::params::apt_release,
  $apt_repo        = $freight::params::apt_repo,
  $manage_apache   = true,
  $ssl             = false,
  $default_vhost   = true,
  $servername      = $freight::params::servername
) inherits freight::params {
  if $::osfamily != 'Debian' {
    fail('This module only works on Debian or derivatives like Ubuntu')
  }
  validate_bool($manage_apt)
  validate_bool($manage_apache)
  validate_bool($apt_include_src)
  validate_bool($lazy_gpg)

  # Version validation - needs improvement
  validate_re($version, 'present|installed|latest|^[.+_0-9a-zA-Z:-]+$')

  if $manage_apt {
    freight::apt { $apt_label:
      location    => $apt_location,
      repo        => $apt_repo,
      release     => $apt_release,
      manage_key  => true,
      key         => $apt_key,
      source      => $apt_ksource,
      include_src => $apt_include_src,
      notify      => Package['freight']
    }
  }

  file { $conf_file:
    ensure    => present,
    content   => template('freight/freight.conf.erb'),
    subscribe => Package['freight']
  }

  file { $varlib:
    ensure    => directory,
    subscribe => Package['freight']
  }

  file { $varcache:
    ensure    => directory,
    subscribe => Package['freight']
  }

  # Felt there should be an option to generate a
  # gpg key.
  if $lazy_gpg {
    # Ensure entropy
    package { 'rng-tools':
      ensure => present
    }

    # Key off the .gnupg directory existing
    # and then off email
    file { '/root/.gnupg':
      ensure => directory,
      notify => Exec['freight::generate_entropy']
    } ->
    file { "/root/.gnupg/${gpg_email}.added":
      ensure => present,
      notify => Exec[
        'freight::generate_entropy',
        'freight::generate_gpg_key' ]
    }

    # Spin up rngd to /dev/urandom to gen entropy
    exec { 'freight::generate_entropy':
      command     => '/usr/sbin/rngd -r /dev/urandom',
      require     => Package['rng-tools'],
      refreshonly => true,
      notify      => Exec['freight::generate_gpg_key']
    }
    # And generate the key
    exec { 'freight::generate_gpg_key':
      command     => template('freight/gpg_generate.erb'),
      refreshonly => true,
    }
  }

  if $manage_apache {
    package { 'freight':
      ensure => $version
    }
    class { 'freight::apache':
      servername    => $servername,
      default_vhost => $default_vhost,
      ssl           => $ssl,
      docroot       => $varcache
    }
  } else {
    package { 'freight':
      ensure => $version
    }
  }
}
