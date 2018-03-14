# Root unlocked
describe command('selinuxenabled') do
  it { should exist }
  its('exit_status') { should eq 0 }
end

describe command('getenforce') do
  it { should exist }
  its('stdout') { should match (/^Enforcing/) }
end
