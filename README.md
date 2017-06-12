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

By default clients will listen on `::`, use port `4222`, monitoring will be on port `8222` and
cluster comms will use port `4223`.

This module installs the included `gnatsd` binary to `/usr/sbin/gnatsd` by
default and manages either a SysV init script (`nats::service_type =>
'init'`), an Upstart job (`nats::service_type => 'upstart'`) or a Systemd
Unit file (`nats::service_type => 'systemd'`) depending on the underlying
operating system.

Default logging is to syslog for `systemd`, to `/var/log/upstart/gnatsd.log` for
`upstart` and to `/var/log/gnatsd-stderr.log` and `/var/log/gnatsd-stdout.log`
for `init`. Various other paths can be configured via the class properties.

It may happen that you run in a high amount of TCP connections. The default
amount of open files is 1024 (each TCP connection is a file descriptor => is a
file). You can increase this if you use the systemd init system. The option is
limit\_nofile. You can check the amount of open TCP connections by:

```bash
lsof -p $(pgrep --pidfile /var/run/gnatsd.pid) | grep TCP -c
```

### Cluster of 3 Servers

Given 3 servers with cluster ports `4223` and password `S3cret` you configure the the
class with the FQDNs of your 3 servers and a password

```puppet
class{"nats":
  servers => ["nats1.example.net", "nats2.example.net", "nats3.example.net"],
  routes_password => "S3cret"
}
```

### Standalone Server

If you do not specify servers, it becomes a standalone node:

```puppet
include nats
```

### Change the service type manually (`systemd`, `upstart` `redhat` or `init`)

The module installs a Systemd Unit file, an Upstart Job or a classic SysV init
script, depending on the underlying operating system. Usually there is no need
to set the service type manually.

```puppet
class { 'nats':
  service_type => 'systemd', # or 'upstart', `redhat` or 'init'
}
```

### Collectd Stats

If you use the `puppet/collectd` module to manage collectd this module can configure a metrics
poller for your NATS instances

```puppet
class{"nats":
  servers => ["nats1.example.net", "nats2.example.net", "nats3.example.net"],
  routes_password => "S3cret",
  manage_collectd => true
}
```

## Compatibility

The module supports Debian, Ubuntu and RedHat/CentOS. You should be able to use
it on other operating systems not directly supported as well, provided you set
the `nats::service_type` parameter (it defaults to `init`).

For Systemd support the module depends on the `camptocamp/systemd` module.
