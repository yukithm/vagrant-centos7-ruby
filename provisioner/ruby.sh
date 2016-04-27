#--------------------------------------
# ruby
#
# Environment Variables:
#   RUBY_VERSION: ruby version (e.g. "2.2.3")
#--------------------------------------

echo "install: --no-ri --no-rdoc" >>/root/.gemrc
echo "update: --no-ri --no-rdoc" >>/root/.gemrc

echo "install: --no-ri --no-rdoc" >>/home/vagrant/.gemrc
echo "update: --no-ri --no-rdoc" >>/home/vagrant/.gemrc
chown vagrant:vagrant /home/vagrant/.gemrc

if [ -n "$RUBY_VERSION" ]; then
  rbenv install $RUBY_VERSION
  rbenv global $RUBY_VERSION
fi
