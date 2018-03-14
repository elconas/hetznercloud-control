describe file('/boot/grub2/user.cfg') do
  its('content') { should match(%r{^GRUB2_PASSWORD=grub.pbkdf2.sha512}) }
end
