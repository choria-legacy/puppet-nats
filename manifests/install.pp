# Manage the NATS binary
class nats::install {
  contain "nats::install::${nats::service_type}"

  if $nats::manage_group and $nats::group != "root" {
    group { $nats::group:
      ensure    => present,
      allowdupe => false,
    }
  }

  if $nats::manage_user and $nats::user != "root" {
    user { $nats::user:
      ensure    => present,
      gid       => $nats::group,
      allowdupe => false,
    }
  }

  file {
    default:
      owner => $nats::user,
      group => $nats::group,
      mode  => "0755";

    $nats::binpath:
      source => $nats::binary_source;

    $nats::configdir:
      ensure => "directory";
  }

  Class[$name] ~> Class["nats::service"]
}
