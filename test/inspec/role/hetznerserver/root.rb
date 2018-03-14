# Root unlocked
describe file('/etc/shadow') do
  its('content') { should match(%r{^root:}) }
  its('content') { should_not match(%r{^root:\!}) }
end

describe file('/root/original-ks.cfg') do
  it { should_not exist }
end

describe file('/root/anaconda-ks.cfg') do
  it { should_not exist }
end
