# == Class: mod_auth_cas
#
# A module for configuring the mod_auth_cas Apache module.
#
# === Parameters
#
# [*loginurl*]
#   The full URL of the CAS login page. All non-authenticated users
#   will be redirected here.
#
# [*validateurl*]
#   The full URL of the CAS ticket validation service.
#
# [*cachebase*]
#   The mod_auth_cas cache directory. The cache directory itself
#   will be created here.
#
# [*certificatepath*]
#   The location of any SSL certificates needed to validate the CAS
#   loginurl and validateurl.
#
# [*validatesaml*]
#   If enabled the CAS server response will be treated as a SAML
#   response and parsed for attributes. Valid values are 'On' or
#   'Off'. By default this is not set so will be whatever the 
#   mod_auth_cas default is.
#
# [*debug*]
#   Whether to enable debug logging to the Apache error_log. Valid
#   values are 'On' and 'Off'. By default this is not set so will
#   be whatever the mod_auth_cas default is.
#
# === Authors
#
# Stephen Grier <s.grier at ucl.ac.uk>
#
# == Class: mod_auth_cas
class mod_auth_cas (
  $loginurl = ylookup('mod_auth_cas::loginurl', 'https://cas.example.com/cas/login'),
  $validateurl = ylookup('mod_auth_cas::validateurl', 'https://cas.example.com/cas/serviceValidate'),
  $cachebase = ylookup('mod_auth_cas::cachebase', '/var/cache/httpd'),
  $certificatepath = ylookup('mod_auth_cas::certificatepath', '/etc/ssl/certs'),
  $version = ylookup('mod_auth_cas::version', undef),
  $validatesaml = ylookup('mod_auth_cas::validatesaml', undef),
  $debug = ylookup('mod_auth_cas::debug', undef),
) {
  # The mod_auth_cas package name.
  $package = $::osfamily ? {
    'RedHat' => 'mod_auth_cas',
    'Debian' => 'libapache2-mod-auth-cas',
    default  => 'mod_auth_cas',
  }

  # The config dir path.
  $configpath = $::osfamily ? {
    'RedHat' => '/etc/httpd/conf.d',
    'Debian' => '/etc/apache2/conf-enabled',
    default  => '/etc/httpd/conf.d',
  }

  # Install the mod_auth_cas package,
  package { $package :
    ensure  => installed,
    require => Package['httpd'],
    before  => Service['httpd'],
  }

  # The main mod_auth_cas config file.
  file { "${configpath}/auth_cas.conf":
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('mod_auth_cas/auth_cas.conf.erb'),
    notify  => Service['httpd'],
    require => Package['httpd'],
  }

  # The CAS cache directory.
  file { [ $cachebase, "${cachebase}/mod_auth_cas"] :
    ensure => directory,
    owner  => 'root',
    group  => 'apache',
    mode   => '0775',
  }
}
