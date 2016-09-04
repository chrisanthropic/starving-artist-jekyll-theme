set -ex

date > /etc/vagrant_box_build_time

# set pkg path for users
export PKG_PATH=http://ftp3.usa.openbsd.org/pub/OpenBSD/`uname -r`/packages/`arch -s`/
echo "export PKG_PATH=$PKG_PATH" >> /root/.profile
echo "export PKG_PATH=$PKG_PATH" >> /home/vagrant/.profile

# install bash and wget
pkg_add bash wget

# set vagrant shell to bash
usermod -s /usr/local/bin/bash vagrant

# sudo
echo "# Uncomment to allow people in group wheel to run all commands without a password" >> /etc/sudoers
echo "%wheel        ALL=(ALL) NOPASSWD: SETENV: ALL" >> /etc/sudoers

# setup the vagrant key
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant.vagrant /home/vagrant/.ssh

perl -pi -e 's/(?<=:maxproc-(?:max|cur)=)\d+(?=:)/1024/' -- /etc/login.conf

/sbin/halt -p
