# frozen_string_literal: true

require_relative "../spec_helper"

if os[:family] == "openbsd"
  ports = [
    { proto: "tcp", number: 53 },
    { proto: "udp", number: 53 },
    { proto: "tcp", number: 80 },
    { proto: "tcp", number: 443 },
    { proto: "tcp", number: 22 }
  ]
  format_pass_any_port = "pass in quick proto %s from any to any port = %d"

  describe command "pfctl -sr" do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match(/^block return all/) }
    its(:stdout) { should match(/^pass in quick proto icmp all/) }
    ports.each do |port|
      its(:stdout) { should match(%r{#{Regexp.escape(format(format_pass_any_port, port[:proto], port[:number]))}(?: flags S/SA)?}) }
    end
    its(:stdout) { should match(%r{^pass out quick all flags S/SA}) }
  end
end
