Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size => '512',
  :disk_size => '8192',
  :disk_format => 'VDI',
  :hostiocache => 'off',
  :os_type_id => 'OpenBSD_64',
  :iso_file => 'OpenBSD-5.5-amd64.iso',
  :iso_src => 'http://ftp3.usa.openbsd.org/pub/OpenBSD/5.5/amd64/install55.iso',
  :iso_sha256 => 'cc465ce3f8397883e91c6e1a8a98b1b3507a338984bbfe8978050c5f8fdcaf3f',
  :iso_download_timeout => '1000',
  :boot_wait => '50',
  :boot_cmd_sequence => [
    'I<Enter>',             # I - install
    'us<Enter>',            # set the keyboard
    'OpenBSD55-x64<Enter>', # set the hostname
    '<Enter>',              # Which nic to config ? [em0]
    '<Enter>',              # do you want dhcp ? [dhcp]
    '<Wait>' * 5,
    'none<Enter>',          # IPV6 for em0 ? [none]
    'done<Enter>',          # Which other nic do you wish to configure [done]
    'vagrant<Enter>',       # Pw for root account
    'vagrant<Enter>',
    'yes<Enter>',           # Start sshd by default ? [yes]
    'no<Enter>',            # Start ntpd by default ? [yes]
    'no<Enter>',            # Do you want the X window system [yes]
    'vagrant<Enter>',       # Setup a user ?
    'vagrant<Enter>',       # Full username
    'vagrant<Enter>',       # Pw for this user
    'vagrant<Enter>',
    'no<Enter>',            # Do you want to disable sshd for root ? [yes]
    'GB<Enter>',            # What timezone are you in ?
    '<Enter>',              # Available disks [sd0]
    '<Enter>',              # Use DUIDs rather than device names in fstab ? [yes]
    'W<Enter>',             # Use (W)whole disk or (E)edit MBR ? [whole]
    'A<Enter>',             # Use (A)auto layout ... ? [a]
    '<Wait>' * 70,
    'cd<Enter>',            # location of the sets [cd]
    '<Enter>',              # Available cd-roms : cd0
    '<Enter>',              # Pathname to sets ? [5.5/amd64]
    '-game55.tgz<Enter>',   # Remove games and X
    '-xbase55.tgz<Enter>',
    '-xetc55.tgz<Enter>',
    '-xshare55.tgz<Enter>',
    '-xfont55.tgz<Enter>',
    '-xserv55.tgz<Enter>',
    'done<Enter>',
    '<Wait>',
    'yes<Enter>',           # CD does not contain SHA256.sig (5.5) Continue without verification?
    'done<Enter>',          # Done installing ?
    '<Wait>' * 6,
    'yes<Enter><Wait>',     # Time appears wrong. Set to ...? [yes]
    '<Wait>' * 6,
    'reboot<Enter>',
    '<Wait>' * 6,
  ],
  :kickstart_port => '7122',
  :kickstart_timeout => '300',
  :kickstart_file => '',
  :ssh_login_timeout => '10000',
  :ssh_user => 'root',
  :ssh_password => 'vagrant',
  :ssh_key => '',
  :ssh_host_port => '7222',
  :ssh_guest_port => '22',
  :sudo_cmd => "sh '%f'",
  :shutdown_cmd => '/sbin/halt -p',
  :postinstall_files => %w[../openbsd-postinstall.sh],
  :postinstall_timeout => '10000',
  :skip_iso_transfer => true,
})
