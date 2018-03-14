## Basic SSH Tests
describe port(22) do
  it { should be_listening }
  its('protocols') {should include 'tcp'}
end
describe sshd_config do
   its('PermitRootLogin') { should eq('without-password') }
end
describe sshd_config do
   its('PasswordAuthentication') { should eq('no') }
end
