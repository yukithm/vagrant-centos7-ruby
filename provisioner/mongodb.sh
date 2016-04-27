#--------------------------------------
# MongoDB
#--------------------------------------

# Add MongoDB repository
cat <<'EOS' >/etc/yum.repos.d/mongodb-org-3.0.repo
[mongodb-org-3.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1
EOS

yum -y install mongodb-org

# Use WiredTiger
cp /etc/mongod.conf{,.orig}
sed -i -f - /etc/mongod.conf <<'EOS'
/^  dbPath:/a\  directoryPerDB: true
s/^#  engine:/  engine: wiredTiger/
s/^#  wiredTiger:/  wiredTiger:/
/  wiredTiger:/a\    engineConfig:\
      cacheSizeGB: 1\
      directoryForIndexes: true\
      statisticsLogDelaySecs: 0\
    collectionConfig:\
      blockCompressor: "snappy"\
    indexConfig:\
      prefixCompression: true
EOS

# Disable Transparent Huge Pages (THP)
# See: https://docs.mongodb.org/manual/tutorial/transparent-huge-pages/
cat <<'EOS' >/etc/init.d/disable-transparent-hugepages
#!/bin/sh
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    unset thp_path
    ;;
esac
EOS
chmod 755 /etc/init.d/disable-transparent-hugepages
chkconfig --add disable-transparent-hugepages

mkdir /etc/tuned/no-thp
cat <<'EOS' >/etc/tuned/no-thp/tuned.conf
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
EOS
tuned-adm profile no-thp

# Change ulimit settings
# See: https://docs.mongodb.org/manual/reference/ulimit/
cat <<'EOS' >/etc/security/limits.d/99-mongodb-nproc.conf
mongod     -       fsize     unlimited
mongod     -       cpu       unlimited
mongod     -       as        unlimited
mongod     -       nofile    64000
mongod     -       rss       unlimited
mongod     -       nproc     64000
EOS

chkconfig mongod on
service mongod start
