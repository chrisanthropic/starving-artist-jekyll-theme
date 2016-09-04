set -ex

ntpdate -v -b in.pool.ntp.org
date > /etc/vagrant_box_build_time

ASSUME_ALWAYS_YES=yes pkg info
pkg install -y sudo bash-static wget

# setup the vagrant key
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# passwordless sudo
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# undo customizations
sed -i '' -e '/^REFUSE /d' /etc/portsnap.conf
sed -i '' -e '/^PermitRootLogin /d' /etc/ssh/sshd_config

# set vagrant shell to bash
pw usermod vagrant -s /usr/local/bin/bash

# cleanup
sudo pkg clean -y
rm -rf \
  /var/db/freebsd-update/* \
  /var/cache/pkg/* \
  /etc/ssh/ssh_host_key* \
  /usr/src \
  /var/log/* \
  /var/tmp/* \
  /tmp/*
dd if=/dev/zero of=filler bs=1M || rm filler

shutdown -p now
