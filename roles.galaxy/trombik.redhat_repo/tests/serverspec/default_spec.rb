require "spec_helper"

packages = %w[epel-release]
repo_name = "epel"

# choose a package that is not included in the default repos
package_not_in_default_repo = %w[python-pip]

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe file("/etc/yum.repos.d/#{repo_name}.repo") do
  it { should be_file }
  its(:content) { should match(/^\[#{ repo_name }\]\nenabled = 1\ngpgcheck = 1\nmirrorlist = #{ Regexp.escape('http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64') }/) }
end

describe "Command yum repolist" do
  let(:result) { command "yum repolist" }
  it "exit status is zero" do
    expect(result.exit_status).to eq 0
  end
  it "stderr is empty", retry: 3, retry_wait: 1 do
    # XXX sometimes, stderr is not empty due to slow response time, and
    # network glitch, retry if so
    #
    # XXX do not use `let`-ed, or cached, command result
    expect(command("yum repolist").stderr).to eq ""
  end

  it "stdout shows the repository has been added" do
    expect(result.stdout).to match(/^epel\s+epel repository\s+[0-9,]+$/)
  end
end

package_not_in_default_repo.each do |p|
  describe command("yum install -y #{p}") do
    its(:stdout) do
      skip "yum sometimes takes more than 600 sec https://github.com/reallyenglish/ansible-role-redhat-repo/issues/4" if ENV["JENKINS_HOME"]
      should match(/Complete!/)
    end
    its(:stderr) do
      skip "yum sometimes takes more than 600 sec https://github.com/reallyenglish/ansible-role-redhat-repo/issues/4" if ENV["JENKINS_HOME"]
      should_not match(/Error:/)
    end
    its(:exit_status) do
      skip "yum sometimes takes more than 600 sec https://github.com/reallyenglish/ansible-role-redhat-repo/issues/4" if ENV["JENKINS_HOME"]
      should eq 0
    end
  end
end
