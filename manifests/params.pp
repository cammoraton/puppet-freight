class freight::params {
  if $::osfamily != 'Debian' {
    fail('This module only works on Debian or derivatives like Ubuntu')
  }
  if($::fqdn) {
    $servername = $::fqdn
  } else {
    $servername = $::hostname
  }

  $conf_file    = '/etc/freight.conf'
  
  # Directories for the Freight library and Freight cache.  Your web
  # server's document root should be `$VARCACHE`.
  $varlib       = '/var/lib/freight'
  $varcache     = '/var/cache/freight'

  # Default `Origin` and `Label` fields for `Release` files.
  $origin       = 'Freight'
  $label        = 'Freight'

  # Cache the control files after each run (on), or regenerate them every
  # time (off).
  $cache        = 'off'

  # Whether to follow symbolic links in `$VARLIB` to produce extra components
  # in the cache directory (on) or not (off).
  $symlinks     = 'off'

  # GPG key to use to sign repositories.  This is required by the `apt`
  # repository provider.  Use `gpg --gen-key` (see `gpg`(1) for more
  # details) to generate a key and put its email address here. 
  $gpg_fullname = "Example User"
  $gpg_email    = 'example@example.com'
  $gpg_type     = 'RSA'
  $gpg_bits     = '1024'
  
  $cron_cmd     = '/usr/bin/freight cache > /dev/null'
  $cron_user    = 'root'
  $cron_hour    = '*'
  $cron_minute  = '*/30'
  
  # Installation information
  $apt_label    = 'freight'
  $key          = '5F93AE37'
  $key_source   = 'http://packages.rcrowley.org/keyring.gpg'
  
  $apt_location = 'http://packages.rcrowley.org'
  $apt_release  = $::lsbdistcodename
  $apt_repo     = 'main'
  
  # Apache defaults
}