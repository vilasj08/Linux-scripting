#!/bin/bash
date >> log.txt
echo "Do you want to install nagios [y/n]:"
read ans

if [ $ans == "y" ]
then

echo "Following packages will be installed:"
echo "1. Dependency packges"
echo "2. Nagios"
user=$(whoami)
if [ $user == "root" ]
then
echo "Download and installing required packages"
#Following required packages will be installed
yum install -y httpd httpd-tools php gcc glibc glibc-common gd gd-devel make net-snmp

useradd nagios
groupadd nagcmd
usermod -G nagcmd nagios
usermod -G nagcmd apache
mkdir /root/nagios
cd /root/nagios

echo "Downloading and installing Nagios 4.4.5"
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz
wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar -xvf nagios-4.4.5.tar.gz
tar -xvf nagios-plugins-2.2.1.tar.gz
cd nagios-4.4.5/
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf
htpasswd -b -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios123
echo "Password updated successfully"

#systemctl restart httpd
#cd /root/nagios
#cd nagios-plugins-2.2.1/
#./configure --with-nagios-user=nagios --with-nagios-group=nagios
#make all
#make install
#/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
#systemctl start nagios

else
echo "You are not root user. To run the script log in with root user."
fi

else
echo "Aborted"
fi
