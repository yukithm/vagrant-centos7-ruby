#--------------------------------------
# rbenv
#--------------------------------------

yum -y install gcc gcc-c++ patch openssl-devel zlib-devel ncurses-devel readline-devel \
  sqlite-devel gdbm-devel libffi-devel libxml2-devel libxslt-devel libyaml-devel

(cd /usr/local && \
  git clone git://github.com/sstephenson/rbenv.git && \
  chgrp -R vagrant rbenv && \
  chmod -R g+rwxXs rbenv
)

cat <<'EOS' >/etc/profile.d/rbenv.sh
export RBENV_ROOT=/usr/local/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"
EOS
. /etc/profile.d/rbenv.sh

mkdir /usr/local/rbenv/plugins
(cd /usr/local/rbenv/plugins && \
  git clone git://github.com/sstephenson/ruby-build.git && \
  chgrp -R vagrant ruby-build && \
  chmod -R g+rwxs ruby-build && \
  git clone git://github.com/sstephenson/rbenv-default-gems.git && \
  chgrp -R vagrant rbenv-default-gems && \
  chmod -R g+rwxs rbenv-default-gems
  )

cat <<'EOS' >/usr/local/rbenv/default-gems
bundler
pry
pry-byebug
awesome_print
ruby-prof
rubocop
EOS
chgrp -R vagrant /usr/local/rbenv/default-gems
chmod -R g+r /usr/local/rbenv/default-gems
