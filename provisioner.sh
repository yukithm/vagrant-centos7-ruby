#!/bin/bash
#
# Ruby environment provisioner for Vagrant
#

set -eu

#--------------------------------------
# Configurations
#--------------------------------------

SYSTEM_LOCALE=en_US.utf8
SYSTEM_TIMEZONE=Asia/Tokyo

# CentOS 7 official box uses rsync folder for $HOME/sync
export SYNC_DIR=/home/vagrant/sync
export PROVISIONER_DIR=${SYNC_DIR}/provisioner

# Applications (See provisioner/*.sh)
export PROV_RUBY_VERSION=2.5.0
export PROV_DB_USER=app
export PROV_DB_PASS=app


#--------------------------------------
# Base
#--------------------------------------

# locale and timezone
localectl set-locale LANG=$SYSTEM_LOCALE
timedatectl set-timezone $SYSTEM_TIMEZONE

# man
yum -y install man man-pages man-pages-ja

# dkms
yum -y install epel-release
yum -y install dkms

# update all
yum -y update

# chrony
yum -y install chrony
cp /etc/chrony.conf{,.orig}
sed -i -e "/^makestep/c\\makestep 1 -1" /etc/chrony.conf
systemctl enable chronyd
systemctl start chronyd

# other softwares
yum -y install zsh vim git patch wget screen tree the_silver_searcher
cp /etc/skel/.zshrc /home/vagrant
chown vagrant:vagrant /home/vagrant/.zshrc

# disable firewall, this is development environment
systemctl stop firewalld
systemctl disable firewalld


#--------------------------------------
# Applications
#--------------------------------------

# Workaround for permissions on Windows host
chmod u+x "${PROVISIONER_DIR}"/*.sh

# postgresql
"$PROVISIONER_DIR/postgresql.sh"

# mongodb
"$PROVISIONER_DIR/mongodb.sh"

# redis
"$PROVISIONER_DIR/redis.sh"

# nginx
"$PROVISIONER_DIR/nginx.sh"

# omnibus-chef
# "$PROVISIONER_DIR/omnibus-chef.sh"

# rbenv
"$PROVISIONER_DIR/rbenv.sh"

# ruby
"$PROVISIONER_DIR/ruby.sh"

# nodejs
# (required for Rails execjs)
"$PROVISIONER_DIR/nodejs.sh"


#--------------------------------------
# Utilities
#--------------------------------------

# tig (latest version instead of epel version)
"$PROVISIONER_DIR/tig.sh"

# tmux
"$PROVISIONER_DIR/tmux.sh"

# direnv
"$PROVISIONER_DIR/direnv.sh"


#--------------------------------------
# User defined provisioner
#--------------------------------------

if [[ -f "${SYNC_DIR}/user-provisioner.sh" ]]; then
    # /bin/sh "${SYNC_DIR}/user-provisioner.sh"

    # Workaround for permissions and shebang
    chmod u+x "${SYNC_DIR}/user-provisioner.sh"
    "${SYNC_DIR}/user-provisioner.sh"
fi


#--------------------------------------
# Cleanup
#--------------------------------------

# clean yum cache
yum clean all
