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

cat >/etc/yum.repos.d/cloudera-manager.repo <<EOL
[cloudera-repo]
name=cloudera-manager
baseurl=http://master.local/cloudera-repos/cm6/
enabled=1
gpgcheck=0
EOL