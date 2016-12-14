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

Logging is to syslog for `systemd` and to `/var/log/upstart/gnatsd.log` for
`upstart`. Various other paths can be configured via the class properties.

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

### Select the service type (`systemd` or `upstart`)

The default service type is `systemd`. The module will install a systemd unit file:

```puppet
class{"nats":
  service_type => "systemd", # the default
}
```

On distributions like Ubuntu 12.04 and 14.04 you should set the system type to
`upstart`. The module will install an Upstart job:

```puppet
class{"nats":
  service_type => "upstart",
}
```

### Collectd Stats

If you use the `puppet/collectd` module to manage collectd this module can configure a metrics
poller for your NATS instances

```
class{"nats":
  servers => ["nats1.example.net", "nats2.example.net", "nats3.example.net"],
  routes_password => "S3cret",
  manage_collectd => true
}
```

## Compatibility

It supports Systemd based Debian and RedHat systems via the
`camptocamp/systemd` and Upstart based systems like Ubuntu. Use the
`nats::service_type` parameter to select either `systemd` (the default) or
`upstart`.
