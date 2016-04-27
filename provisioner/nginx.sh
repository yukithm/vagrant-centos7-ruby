#--------------------------------------
# nginx
#--------------------------------------

# Add nginx yum repository
cat <<'EOS' >/etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
EOS

# install nginx
yum -y install nginx

# TODO: configure nginx

systemctl enable nginx
systemctl start nginx
