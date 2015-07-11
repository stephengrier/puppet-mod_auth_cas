# mod_auth_cas

#### Table of Contents

1. [Overview](#overview)
2. [Usage](#usage)
3. [Parameters](#parameters)

## Overview

puppet-mod_auth_cas is a puppet module for configuring the mod_auth_cas Apache module.
mod_auth_cas is an Apache 2.0/2.2 compliant module that supports the CASv1
and CASv2 protocols.

This module depends on the ylookup function for looking up configuration from
YAML files.

## Usage

The simplest way to use the mod_auth_cas modules is so simply include it and
place the relevant configuration options in the extdata YAML files:

```puppet
include mod_auth_cas
```

```bash
$ cat /etc/puppet/manifests/extdata/foo.example.com.yaml
mod_auth_cas::loginurl: https://cas.example.com/cas/login
mod_auth_cas::validateurl: https://cas.example.com/cas/serviceValidate
```

Alternatively you can provide the configuration directly as parameters:

```puppet
class { 'mod_auth_cas':
  loginurl => 'https://cas.example.com/cas/login',
  validateurl => 'https://cas.example.com/cas/serviceValidate',
}
```

## Parameters

[*loginurl*]
  The full URL of the CAS login page. All non-authenticated users
  will be redirected here.

[*validateurl*]
  The full URL of the CAS ticket validation service.

[*cachebase*]
  The mod_auth_cas cache directory. The cache directory itself
  will be created here.

[*certificatepath*]
  The location of any SSL certificates needed to validate the CAS
  loginurl and validateurl.

[*validatesaml*]
  If enabled the CAS server response will be treated as a SAML
  response and parsed for attributes.

[*debug*]
  Whether to enable debug logging to the Apache error_log.

