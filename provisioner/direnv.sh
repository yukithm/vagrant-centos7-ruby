#--------------------------------------
# direnv
#
# Environment Variables:
#   DIRENV_VERSION: direnv version (e.g. "2.8.1")
#--------------------------------------

DIRENV_VERSION=${DIRENV_VERSION:-2.8.1}

# yum -y install golang
# git clone -b v2.8.1 https://github.com/direnv/direnv.git /opt/src/direnv
# (cd /opt/src/direnv && make install)

curl -L -o /usr/local/bin/direnv "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64"
chmod +x /usr/local/bin/direnv

echo 'eval "$(direnv hook bash)"' >>/home/vagrant/.bashrc
echo 'eval "$(direnv hook zsh)"' >>/home/vagrant/.zshrc
