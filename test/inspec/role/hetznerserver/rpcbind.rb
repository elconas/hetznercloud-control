# Portmap should removed
describe package('rpcbind') do
  it { should_not be_installed }
end
describe port(111) do
  it { should_not be_listening }
end


