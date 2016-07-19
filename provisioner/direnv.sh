#!/bin/bash -eu
#--------------------------------------
# direnv
#
# Environment Variables:
#   PROV_DIRENV_VERSION: direnv version (e.g. "2.9", "latest")
#--------------------------------------

: ${PROV_DIRENV_VERSION:=${1:-latest}}

# yum -y install golang
# git clone -b v2.8.1 https://github.com/direnv/direnv.git /opt/src/direnv
# (cd /opt/src/direnv && make install)

if [[ "$PROV_DIRENV_VERSION" == "latest" ]]; then
    url=$(curl --silent https://api.github.com/repos/direnv/direnv/releases/latest \
        | grep --only-matching "https://.\+direnv.linux-amd64")
    [[ -n "$url" ]] || (echo "cannot detect latest version" >&2 && exit 1)
else
    url="https://github.com/direnv/direnv/releases/download/v${PROV_DIRENV_VERSION}/direnv.linux-amd64"
fi

curl --location --output /usr/local/bin/direnv "$url"
chmod +x /usr/local/bin/direnv

echo 'eval "$(direnv hook bash)"' >>/home/vagrant/.bashrc
echo 'eval "$(direnv hook zsh)"' >>/home/vagrant/.zshrc
