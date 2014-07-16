require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'ci/reporter/rake/rspec'

# Lint configuration
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp"]
# Autoloader errors every. time.
PuppetLint.configuration.send('disable_autoloader_layout')

# Reports directory for CI reporter
ENV['CI_REPORTS'] = 'reports'  