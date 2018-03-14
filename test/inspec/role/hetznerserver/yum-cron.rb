# Yum cron should be enabled
describe package('yum-cron') do
  it { should be_installed }
end
describe service('yum-cron') do
  it { should be_running }
  it { should be_enabled }
end
