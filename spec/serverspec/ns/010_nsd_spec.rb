# frozen_string_literal: true

require_relative "../spec_helper"

domains = [
  {
    name: "trombik.org.",
    ns: %w[a.ns.trombik.org. b.ns.trombik.org.]
  },
  {
    name: "mkrsgh.org.",
    ns: %w[a.ns.mkrsgh.org. b.ns.mkrsgh.org.]
  }
]

context "after provision finishes" do
  domains.each do |domain|
    describe command("dig @127.0.0.1 ns #{domain[:name]} +norec") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/^;; flags: qr aa; QUERY: 1, ANSWER: #{domain[:ns].length}, AUTHORITY: 0, ADDITIONAL: #{domain[:ns].length}$/) }
      domain[:ns].each do |ns|
        its(:stdout) { should match(/^#{ns}\s+\d+\s+IN\s+A\s+\d+/) }
      end
      its(:stderr) { should eq "" }
    end
  end

  describe command("dig @127.0.0.1 chaos txt version.bind") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should_not match(/version\.bind\..*".*"/) }
  end
end
