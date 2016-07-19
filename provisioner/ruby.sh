#!/bin/bash -eu
#--------------------------------------
# ruby
#
# Environment Variables:
#   PROV_RUBY_VERSION: ruby version (e.g. "2.3.1")
#--------------------------------------

: ${PROV_RUBY_VERSION:=$1}

echo "install: --no-ri --no-rdoc" >>/root/.gemrc
echo "update: --no-ri --no-rdoc" >>/root/.gemrc

echo "install: --no-ri --no-rdoc" >>/home/vagrant/.gemrc
echo "update: --no-ri --no-rdoc" >>/home/vagrant/.gemrc
chown vagrant:vagrant /home/vagrant/.gemrc

if [ -n "$PROV_RUBY_VERSION" ]; then
    # rbenv is not initialized in provisioning shell
    . /etc/profile.d/rbenv.sh

    rbenv install "$PROV_RUBY_VERSION"
    rbenv global "$PROV_RUBY_VERSION"
fi
