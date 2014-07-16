# Type: freight::apt
#
# 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define freight::apt (
  $location,
  $repo,
  $release        = $::lsbdistcodename,
  $include_src    = false,
  $manage_key     = false,
  $key            = undef,
  $source         = undef
) {
  # Nearly never hurts to over test
  if $::osfamily != 'Debian' {
    fail('This module only works on Debian or derivatives like Ubuntu')
  }

  validate_bool($manage_key)
  validate_bool($include_src)

  # Suck in apt
  include ::apt

  # If we're managing the repo key, validate things
  if $manage_key {
    if $key == undef {
      fail('Define[\'freight::apt\']: key undefined')
    }
    if $source == undef {
      fail('Define[\'freight::apt\']: source undefined')
    }

    apt::key { $key:
      key_source => $source,
      notify     => Apt::Source[ $name ]
    }
  }
  apt::source { $name:
    location    => $location,
    release     => $release,
    repos       => $repo,
    include_src => $include_src
  }
}