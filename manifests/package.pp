# Manage the NATS package
class nats::package {
  package { $nats::package_name:
    ensure => $nats::package_ensure,
  }
}
