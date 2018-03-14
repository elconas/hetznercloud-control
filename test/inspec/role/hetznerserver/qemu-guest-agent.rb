describe package('qemu-guest-agent') do
  it { should be_installed }
end
describe service('qemu-guest-agent') do
  it { should be_running }
  it { should be_enabled }
end
describe file('/etc/sysconfig/qemu-ga') do
  its('content') { should match(%r{^BLACKLIST_RPC=guest-exec,guest-exec-status,guest-file-close,guest-file-flush,guest-file-open,guest-file-read,guest-file-seek,guest-file-write,guest-get-fsinfo,guest-get-memory-block-info,guest-get-memory-blocks,guest-get-time,guest-get-vcpus,guest-info,guest-network-get-interfaces,guest-set-memory-blocks,guest-set-time,guest-set-user-password,guest-set-vcpus$}) }
end
