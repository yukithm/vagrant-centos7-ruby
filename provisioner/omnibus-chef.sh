#--------------------------------------
# omnibus-chef and ruby configuration
#
# Environment Variables:
#  OMNIBUS_CHEF_VERSION: version (e.g. "latest", "12.0.2")
#  OMNIBUS_CHEF_ADD_PATH: add $PATH if set
#--------------------------------------

# omnibus-chef
if [[ -z "$OMNIBUS_CHEF_VERSION" || "$OMNIBUS_CHEF_VERSION" == "latest" ]]; then
  curl -L https://www.chef.io/chef/install.sh | bash
else
  curl -L https://www.chef.io/chef/install.sh | bash -s -- -v "$OMNIBUS_CHEF_VERSION"
fi

# Add path
if [[ -n "$OMNIBUS_CHEF_ADD_PATH" ]]; then
  cat <<'EOS' >/etc/profile.d/omnibus-chef.sh
export PATH="/opt/chef/bin:/opt/chef/embedded/bin:$PATH"
EOS
fi

# disable installing documents for gems
echo "install: --no-ri --no-rdoc" >>/root/.gemrc
echo "update: --no-ri --no-rdoc" >>/root/.gemrc

echo "install: --no-ri --no-rdoc" >>/home/vagrant/.gemrc
echo "update: --no-ri --no-rdoc" >>/home/vagrant/.gemrc
chown vagrant:vagrant /home/vagrant/.gemrc
