#Configure the local package repository
yum -y install httpd
# Modify configuration information
# AddType application/x-gzip .gz .tgz .parcel
systemctl enable httpd