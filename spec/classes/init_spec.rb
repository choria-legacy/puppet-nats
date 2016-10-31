require 'spec_helper'

describe "nats" do
  let(:facts) do
    {
      "aio_agent_version" => "1.7.0",
      "osfamily" => "RedHat",
      "networking" => {
        "fqdn" => "rspec.example.com"
      }
    }
  end

  context "when building on a supported puppet version" do
    let(:params) do
      {
        :servers => ["rspec.example.com", "other1.example.com", "other2.example.com"],
        :routes_password => "rspec_password",
        :cluster_port => "8223",
        :binary_source => "puppet://rspec/binary"
      }
    end

    it "should calculate the peers correctly" do
      is_expected.to contain_file("/etc/gnatsd/gnatsd.cfg").with_content(/nats-route:\/\/routes:rspec_password@other1.example.com:8223/)
      is_expected.to contain_file("/etc/gnatsd/gnatsd.cfg").with_content(/nats-route:\/\/routes:rspec_password@other2.example.com:8223/)
      is_expected.to_not contain_file("/etc/gnatsd/gnatsd.cfg").with_content(/nats-route:\/\/routes:rspec_password@rspec.example.com:8223/)
    end

    it "should not use collectd by default" do
      is_expected.to_not contain_collectd__plugin__curl_json("gnatsd")
    end

    it "should install the binary, configdir and unit file" do
      is_expected.to contain_file("/usr/sbin/gnatsd").with_source("puppet://rspec/binary")
      is_expected.to contain_file("/etc/gnatsd").with_ensure("directory")
      is_expected.to contain_systemd__unit_file("gnatsd.service") # @todo check content
      is_expected.to contain_service("gnatsd").with_ensure("running")
    end
  end

  context "when building a standalone node" do
    it "should not configure any cluster config" do
      is_expected.to contain_file("/etc/gnatsd/gnatsd.cfg").without_content(/^cluster/)
    end
  end

  context "when requesting collectd" do
    let(:params) {{ :manage_collectd => true }}

    it "should contain the curl_json plugin instance" do
      is_expected.to contain_collectd__plugin__curl_json("gnatsd").with_url("http://localhost:8222/varz")
    end
  end

  context "when using an old puppet" do
    let(:facts) do
      {
        "aio_agent_version" => "1.4.0",
        "networking" => {
          "fqdn" => "rspec.example.com"
        }
      }
    end

    it "should only support recent AIO agent versions" do
      expect {
        is_expected.to(compile)
      }.to raise_error(/Puppet AIO Agent 1.5.2 or newer is needed by the ripienaar-nats module/)
    end
  end
end
