# Manage systemd unit
class nats::install::systemd {

  systemd::unit_file { "${nats::service_name}.service":
    content => epp("nats/systemd_service.epp"),
  }

  Class[$name] ~> Class["nats::service"]
}
