Vagrant.require_version '!= 1.8.5' # OpenBSD can't be halted in 1.8.5

Vagrant.configure('2') do |config|
  # don't mess with keys
  config.ssh.insert_key = false

  # handle manually using rsync
  config.vm.synced_folder '.', '/vagrant', disabled: true

  {
    'linux-x86_64'  => 'boxes/centos-amd64.box',
    'linux-i686'    => 'boxes/centos-i386.box',
    'freebsd-amd64' => 'boxes/freebsd-amd64.box',
    'freebsd-i386'  => 'boxes/freebsd-i386.box',
    'openbsd-amd64' => 'boxes/openbsd-amd64.box',
    'openbsd-i386'  => 'boxes/openbsd-i386.box',
  }.each do |name, location|
    config.vm.define name do |machine|
      machine.vm.hostname = name.gsub('_', '-')
      machine.vm.box = location

      machine.vm.provision :shell, inline: case name
      when /^linux/
        <<-SH
          set -ex
          yum -y install rsync ntpdate make wget gcc gcc-c++ chrpath perl pkg-config autoconf automake libtool nasm
        SH
      when /^freebsd/
        <<-SH
          set -ex
          pkg install -y rsync ntp gmake wget gcc chrpath perl5 pkgconf autoconf automake libtool nasm
        SH
      when /^openbsd/
        <<-SH
          set -ex
          pkg_add -z rsync-- ntp gmake gtar-- wget gcc-4.8.2p2 autoconf-2.69 automake-1.14.1 libtool nasm
          path=/home/vagrant/shared
          mkdir -p $path
          chown vagrant:vagrant $path
          ln -nfs $path /vagrant
        SH
      end

      machine.vm.provision :shell, inline: <<-SH
        set -ex
        mkdir -p /vagrant
        chown vagrant:vagrant /vagrant
      SH
    end
  end
end
