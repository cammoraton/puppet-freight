class freight::params {
  # Directories for the Freight library and Freight cache.  Your web
  # server's document root should be `$VARCACHE`.
  $varlib   = "/var/lib/freight"
  $varcache = "/var/cache/freight"

  # Default `Origin` and `Label` fields for `Release` files.
  $origin   = "Freight"
  $label    = "Freight"

  # Cache the control files after each run (on), or regenerate them every
  # time (off).
  $cache    = "off"

  # Whether to follow symbolic links in `$VARLIB` to produce extra components
  # in the cache directory (on) or not (off).
  $symlinks = "off"

  # GPG key to use to sign repositories.  This is required by the `apt`
  # repository provider.  Use `gpg --gen-key` (see `gpg`(1) for more
  # details) to generate a key and put its email address here.
  $gpg      = "example@example.com"
}