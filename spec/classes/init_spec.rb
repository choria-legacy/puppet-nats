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
        :binary_source => "puppet://rspec/binary",
        :service_type => "systemd"
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
      is_expected.to_not contain_file("gnatsd.upstart")
      is_expected.to_not contain_file("gnatsd upstart initd symlink")
      is_expected.to_not contain_file("gnatsd.sysvinit")
    end
  end

  context "when service_type => upstart" do
    let(:params) do
      {
        :servers => ["rspec.example.com", "other1.example.com", "other2.example.com"],
        :routes_password => "rspec_password",
        :cluster_port => "8223",
        :binary_source => "puppet://rspec/binary",
        :service_type => "upstart"
      }
    end

    it "should install the binary, configdir and Upstart job" do
      is_expected.to contain_file("/usr/sbin/gnatsd").with_source("puppet://rspec/binary")
      is_expected.to contain_file("/etc/gnatsd").with_ensure("directory")
      is_expected.to contain_service("gnatsd").with_ensure("running")
      is_expected.to_not contain_systemd__unit_file("gnatsd.service")
      is_expected.to contain_file("gnatsd upstart initd symlink").with(
        {
          :ensure => 'link',
          :path => '/etc/init.d/gnatsd',
          :target => '/lib/init/upstart-job'
        }
      )
      is_expected.to contain_file("gnatsd.upstart").with(
        {
          :path => '/etc/init/gnatsd.conf',
          :content => %r{^exec \/usr\/sbin\/gnatsd --config \/etc\/gnatsd\/gnatsd\.cfg$}
        }
      )
    end
  end

  context "when service_type => sysvinit " do
    let(:params) do
      {
        :servers => ["rspec.example.com", "other1.example.com", "other2.example.com"],
        :routes_password => "rspec_password",
        :cluster_port => "8223",
        :binary_source => "puppet://rspec/binary",
        :service_type => "sysvinit"
      }
    end

    it "should install the binary, configdir and SysV init.d file" do
      is_expected.to contain_file("/usr/sbin/gnatsd").with_source("puppet://rspec/binary")
      is_expected.to contain_file("/etc/gnatsd").with_ensure("directory")
      is_expected.to contain_service("gnatsd").with_ensure("running")
      is_expected.to_not contain_systemd__unit_file("gnatsd.service")
      is_expected.to contain_file("gnatsd.upstart").with_ensure('absent')
      is_expected.to_not contain_file("gnatsd upstart initd symlink")
      is_expected.to contain_file("gnatsd.sysvinit").with_path('/etc/init.d/gnatsd')
      is_expected.to contain_file("gnatsd.sysvinit").with_content(
        %r{^name="gnatsd"$}
      )
      is_expected.to contain_file("gnatsd.sysvinit").with_content(
        %r{^program="\/usr\/sbin\/gnatsd"$}
      )
      is_expected.to contain_file("gnatsd.sysvinit").with_content(
        %r{^args="--config \/etc\/gnatsd\/gnatsd.cfg --pid \$pidfile"$}
      )
      is_expected.to contain_file("gnatsd.sysvinit").with_content(
        %r{^pidfile="\/var\/run\/gnatsd.pid"$}
      )
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
