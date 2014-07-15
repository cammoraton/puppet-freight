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
  $conf_file       = $freight::params::conf_file,
  $varcache        = $freight::params::varcache,
  $varlib          = $freight::params::varlib,
  $origin          = $freight::params::origin,
  $cache           = $freight::params::cache,
  $symlinks        = $freight::params::symlinks,
  $gpg_email       = $freight::params::gpg_email,
  $gpg_fullname    = $freight::params::gpg_fullname,
  $lazy_gpg        = true,
  $manage_apt      = true,
  $apt_label       = $freight::params::apt_label,
  $apt_key         = $freight::params::key,
  $apt_include_src = false,
  $apt_ksource     = $freight::params::key_source,
  $apt_location    = $freight::params::apt_location,
  $apt_release     = $freight::params::apt_release,
  $apt_repo        = $freight::params::apt_repo,
  $manage_apache   = true
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
    ensure => directory,
    subscribe => Package['freight']
  }
  
  file { $varcache:
    ensure => directory,
    subscribe => Package['freight']
  }
  
  if $lazy_gpg {
    # This is bad
    package { 'rng-tools':
      ensure => present
    }
    
    file { '/root/.gpg':
      ensure => directory,
      notify => Exec['freight::generate_entropy']
    } ->
    file { "/root/.gpg/${gpg_email}_added":
      ensure => present,
      notify => Exec['freight::generate_entropy',
                     'freight::generate_gpg_key']
    }
    
    exec { 'freight::generate_entropy':
      command     => '/usr/sbin/rngd -r /dev/urandom',
      require     => Package['rng-tools'],
      refreshonly => true,
      notify      => Exec['freight::generate_gpg_key']
    }
    exec { 'freight::generate_gpg_key':
      command     => template('freight/gpg_generate.erb'),
      refreshonly => true,
    }
  }
  
  if $manage_apache {
    package { 'freight': 
      ensure => $version
    }
  } else {
    package { 'freight': 
      ensure => $version 
    }
  }
}
