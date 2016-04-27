#!/bin/sh
#
# Ruby environment provisioner for Vagrant
#

#--------------------------------------
# Configurations
#--------------------------------------

SYSTEM_LOCALE=en_US.utf8
SYSTEM_TIMEZONE=Asia/Tokyo
RUBY_VERSION=2.3.0
DB_USER=app
DB_PASS=app

# CentOS 7 official box uses rsync folder for $HOME/sync
SYNC_DIR=/home/vagrant/sync
PROVISIONER_DIR=${SYNC_DIR}/provisioner


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

# postgresql
. "$PROVISIONER_DIR/postgresql.sh"

# mongodb
. "$PROVISIONER_DIR/mongodb.sh"

# redis
. "$PROVISIONER_DIR/redis.sh"

# nginx
. "$PROVISIONER_DIR/nginx.sh"

# omnibus-chef
# . "$PROVISIONER_DIR/omnibus-chef.sh"

# rbenv
. "$PROVISIONER_DIR/rbenv.sh"

# ruby
. "$PROVISIONER_DIR/ruby.sh"

# nodejs
# (required for Rails execjs)
. "$PROVISIONER_DIR/nodejs.sh"


#--------------------------------------
# Utilities
#--------------------------------------

# tig (latest version instead of epel version)
. "$PROVISIONER_DIR/tig.sh"

# tmux
. "$PROVISIONER_DIR/tmux.sh"

# direnv
. "$PROVISIONER_DIR/direnv.sh"


#--------------------------------------
# User defined provisioner
#--------------------------------------

if [[ -f "${SYNC_DIR}/user-provisioner.sh" ]]; then
    # /bin/sh "${SYNC_DIR}/user-provisioner.sh"

    # Workaround for shebang
    chmod u+x "${SYNC_DIR}/user-provisioner.sh"
    "${SYNC_DIR}/user-provisioner.sh"
fi


#--------------------------------------
# Cleanup
#--------------------------------------

# clean yum cache
yum clean all
