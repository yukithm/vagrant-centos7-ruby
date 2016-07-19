#!/bin/bash -eu
#--------------------------------------
# Database
#
# Environment Variables:
#   PROV_DB_USER: user name
#   PROV_DB_PASS: password for user
#   PROV_DB_ENCODING: database encoding (for initdb)
#   PROV_DB_LOCALE: database locale (for initdb)
#--------------------------------------

: ${PROV_DB_USER:=${1:-vagrant}}
: ${PROV_DB_PASS:=${2:-vagrant}}
: ${PROV_DB_ENCODING:=UTF8}
: ${PROV_DB_LOCALE:=C}

yum -y install postgresql postgresql-server postgresql-devel

PGSETUP_INITDB_OPTIONS="--encoding=${PROV_DB_ENCODING} --locale=${PROV_DB_LOCALE}" postgresql-setup initdb

# Add authentication
sed -i -e "/^# \"local\"/a\local   all             ${PROV_DB_USER}                                md5" /var/lib/pgsql/data/pg_hba.conf
sed -i -e "/^# IPv4/a\host    all             ${PROV_DB_USER}        localhost               md5" /var/lib/pgsql/data/pg_hba.conf

systemctl enable postgresql
systemctl start postgresql

# Create user
# Need CREATEDB for Rails
sudo -u postgres psql <<SQL
CREATE USER ${PROV_DB_USER} CREATEDB ENCRYPTED PASSWORD '${PROV_DB_PASS}';
SQL
