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
  $varcache = $freight::params::varcache,
  $varlib   = $freight::params::varlib,
  $origin   = $freight::params::origin,
  $cache    = $freight::params::cache,
  $symlinks = $freight::params::symlinks,
  $gpg      = $freight::params::gpg
) inherits freight::params {
  
}
