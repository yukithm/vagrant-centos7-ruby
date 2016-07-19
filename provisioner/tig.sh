#!/bin/bash -eu
#--------------------------------------
# tig
#--------------------------------------

yum -y install automake ncurses-devel
[[ -d /opt/src ]] || mkdir /opt/src

# latest version instead of epel version
git clone -b release https://github.com/jonas/tig.git /opt/src/tig
(cd /opt/src/tig && ./autogen.sh && ./configure --prefix=/usr/local && make install)
