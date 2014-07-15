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
  $version       = 'installed',
  $varcache      = $freight::params::varcache,
  $varlib        = $freight::params::varlib,
  $origin        = $freight::params::origin,
  $cache         = $freight::params::cache,
  $symlinks      = $freight::params::symlinks,
  $gpg_email     = $freight::params::gpg_email,
  $manage_apt    = true,
  $apt_label     = $freight::params::apt_label,
  $apt_key       = $freight::params::key,
  $apt_ksource   = $freight::params::key_source,
  $apt_location  = $freight::params::apt_location,
  $apt_release   = $freight::params::apt_release,
  $apt_repo      = $freight::params::apt_repo,
  $manage_apache = true
) inherits freight::params {
  if $::osfamily != 'Debian' {
    fail('This module only works on Debian or derivatives like Ubuntu')
  }
  validate_bool($manage_apt)
  validate_bool($manage_apache)
  
  # Version validation - needs improvement
  validate_re($version, 'present|installed|latest|^[.+_0-9a-zA-Z:-]+$')
  
  if $manage_apt {
    freight::apt { $apt_label: 
      location   => $apt_location,
      repo       => $apt_repo,
      release    => $apt_release,
      manage_key => true,
      key        => $apt_key,
      source     => $apt_ksource,
      notify     => Package['freight']
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
