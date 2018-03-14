# Root unlocked
describe file('/etc/shadow') do
  its('content') { should match(%r{^root:}) }
  its('content') { should_not match(%r{^root:\!}) }
end
