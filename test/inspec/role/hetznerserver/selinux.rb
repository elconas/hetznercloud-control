describe firewalld do
  it { should be_running }
  its('default_zone') { should eq 'public' }
  it { should have_service_enabled_in_zone('ssh', 'public') }
end
