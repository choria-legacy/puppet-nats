class nats::collectd {
  collectd::plugin::curl_json{"gnatsd":
    url                   => "http://localhost:${nats::monitor_port}/varz",
    instance              => "gnatsd",
    keys                  => {
      "max_payload"       => {"type"   => "bytes"},
      "max_control_line"  => {"type"   => "gauge"},
      "max_pending_size"  => {"type"   => "bytes"},
      "mem"               => {"type"   => "bytes"},
      "connections"       => {"type"   => "gauge"},
      "total_connections" => {"type"   => "counter"},
      "routes"            => {"type"   => "gauge"},
      "remotes"           => {"type"   => "gauge"},
      "in_msgs"           => {"type"   => "counter"},
      "out_msgs"          => {"type"   => "counter"},
      "in_bytes"          => {"type"   => "bytes"},
      "out_bytes"         => {"type"   => "bytes"},
      "slow_consumers"    => {"type"   => "gauge"},
      "subscriptions"     => {"type"   => "gauge"}
    }
  }
}
