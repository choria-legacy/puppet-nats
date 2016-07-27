# NATS.io module for AIO Puppet 4

This is a basic module to configure NATS.io for use with Puppet 4, it's intended as
a companion module to the `ripienaar/mcollective` module.

## Overview

This module will install the NATS binary on your machine via source from inside the
module file directory, create a config dir, config file and configure the NATS daemon
for standalone or clustered use.

It only supports verified TLS connections and defaults to using the Puppet certificates and CA.

## Usage

It's recommended that you define a cluster of servers equal to 3 nodes, but it can run
standalone too.

Logging is to syslog and various paths can be configured via the class properties.

By default clients will use port `4222`, monitoring will be on port `8222` and cluster comms will use port `4223`.

### Cluster of 3 Servers

Given 3 servers with cluster ports `4223` and password `S3cret` you configure the the
class with the FQDNs of your 3 servers and a password

```
class{"nats":
  servers => ["nats1.example.net", "nats2.example.net", "nats3.example.net"],
  routes_password => "S3cret"
}
```

### Standalone Server

If you do not specify servers, it becomes a standalone node:

```
include nats
```

## Compatibility

It only supports Systemd based Debian and RedHat systems via the `camptocamp/systemd` module.
