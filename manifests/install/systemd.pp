class nats::install::systemd {
  contain '::systemd'

  systemd::unit_file {"${nats::service_name}.service":
    content => epp('nats/systemd_service.epp'),
  }
}
