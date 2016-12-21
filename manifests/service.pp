class nats::service {
  service { $nats::service_name:
    ensure   => $nats::service_ensure,
    enable   => true,
    provider => $nats::service_provider,
  }
}
