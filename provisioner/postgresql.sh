#--------------------------------------
# Database
#
# Environment Variables:
#   DB_USER: user name
#   DB_PASS: password for user
#--------------------------------------

yum -y install postgresql postgresql-server postgresql-devel

PGSETUP_INITDB_OPTIONS="--encoding=UTF8 --locale=C" postgresql-setup initdb

# Add authentication
sed -i -e "/^# \"local\"/a\local   all             ${DB_USER}                                md5" /var/lib/pgsql/data/pg_hba.conf
sed -i -e "/^# IPv4/a\host    all             ${DB_USER}        localhost               md5" /var/lib/pgsql/data/pg_hba.conf

systemctl enable postgresql
systemctl start postgresql

# Create user
# Need CREATEDB for Rails
sudo -u postgres psql <<SQL
CREATE USER ${DB_USER} CREATEDB ENCRYPTED PASSWORD '${DB_PASS}';
SQL
