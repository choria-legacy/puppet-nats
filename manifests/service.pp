class nats::service {
  service{$nats::service_name:
    ensure => "running",
    enable => true
  }
}
