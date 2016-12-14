class nats::service {
  service{$nats::service_name:
    ensure   => "running",
    enable   => true,
    provider => $nats::service_type,
  }
}
