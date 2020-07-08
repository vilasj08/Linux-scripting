#!/bin/bash
date >>log.txt
echo "Do you want to install gitlab[y/n]:"
read ans

if [ $ans == "y" ]
then
echo "Following packages will be installed"
echo "1. openssh-server"
echo "2. postfix"
echo "3. Gitlab"

user=$(whoami)
if [ $user == "root" ]
then

#Following are the required packages
yum -y install curl policycoreutils openssh-server openssh-clients postfix

#Start the services
systemctl start sshd
systemctl start postfix
systemctl enable sshd
systemctl enable postfix

#Gitlab
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
yum -y install gitlab-ce
cd /etc/gitlab/

#Install vim editor (if required)
yum -y install vim

ip a
#Replace external_url with your systems IP http://<ip here>
#path /etc/gitlab/gitlab.rb
vim gitlab.rb



###################################################################################
If you are using VM
##################################################################################
#Diabled the selinux policy in /etc/sysconfig/selinux
#For temporary do 
echo "Disable the selinus policy"
echo "setenforce 0"
echo "Stop firewalld" 
#Stop firewalld
echo "systemctl stop firewalld"


#Following command will configure gitlab by reading gitlab.rb file
echo "Gitlab reconfiguration"
sudo gitlab-ctl reconfigure

echo "Following commmand might be useful"
echo "To check status"
echo "gitlab-ctl status"
echo "To stop gitlab service"
echo "gitlab-ctl stop"
echo "To start gtilab service"
echo "gitlab-ctl start/gitlab-ctl restart"

echo "To see gitlab"
echo "Type http://<ip> in your browser"

else
echo "You are noot root user. To run the script login with root user"
fi

else
echo "Aborted"
fi
