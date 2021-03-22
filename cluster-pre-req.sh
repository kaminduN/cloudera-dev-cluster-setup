sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# vm.swappiness, is a value from 0-100 that controls the swapping of 
# application data (as anonymous pages) from physical memory to virtual memory on disk. 
# You can set the value of the vm.swappiness parameter for minimum swapping.
# Having a higher value of swappiness is not recommended for Hadoop servers 
# because it can cause lengthy Garbage collection pauses
# sudo sysctl vm.swappiness=10
# Load settings from all system configuration files
#	 sysctl --system
#	 For older versions (that is, if --system does not work):
#	 # Load settings from /etc/sysctl.conf
#	 sysctl -p
echo "vm.swappiness = 10" >> /etc/sysctl.conf

# CDH requires that you configure a Network Time Protocol (NTP) service on each machine in your cluster. 
# Most operating systems include the ntpd service for time synchronization.
yum -y install ntp
systemctl enable ntpd
systemctl start ntpd

 # Transparent Huge Page (THP) is enabled in Linux machines which poorly interact with Hadoop workloads
 # and it degrades the overall performance of Cluster
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled " >> /etc/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag " >> /etc/rc.local

#Configure the local package repository
yum -y install httpd
# Modify configuration information
# AddType application/x-gzip .gz .tgz .parcel
systemctl enable httpd


# Each Hadoop server will be having its own responsibility with multiple services (daemons) running on that. 
# All the servers will be communicating with each other in a frequent manner for various purposes.
# If all the communication happens between the daemons across different servers via the Firewall, it will be an extra burden to Hadoop. 
# So it’s best practice to disable the firewall in the individual servers in Cluster.
# iptables-save > ~/firewall.rules
# systemctl stop firewalld
# systemctl disable firewall


#--------------------

# /etc/hosts
# 10.0.2.15 master.local
# 10.0.2.4  worker1.local



cat >/etc/yum.repos.d/cloudera-manager.repo <<EOL
[cloudera-repo]
name=cloudera-manager
baseurl=http://master.local/cloudera-repos/cm6/
enabled=1
gpgcheck=0
EOL


# vi /etc/yum.repos.d/cloudera-repo.repo
# [cloudera-repo]
# name=cloudera-repo
# baseurl=http://master.local/cloudera-repos/cm6/6.2.0/redhat7/yum/
# enabled=1
# gpgcheck=0 


---------------------

#grant all on *.* to 'temp'@'%' identified by 'temp' with grant option;


#/opt/cloudera/cm/schema/scm_prepare_database.sh mysql -h master.local -utemp -ptemp --scm-host master.local scm scm scm