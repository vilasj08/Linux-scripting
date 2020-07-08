#!/bin/bash
#RPM Based
date >> log.txt
echo "Do you want to install Jenkins[y/n]"
read ans

if [ $ans -eq "y" ]
then
echo "Following Packages will be installed"
echo "1. Java develoment packages"
echo "2. Jenkins"

user=$(whoami)
if [ $user == "root" ]
then

#Installing java
java=`yum list installed | grep java | wc -l`
if [ $java -gt "0" ]
then
	echo "Java Already installed"
else

#Installing java development packages1
echo "Installing java"
yum install java-1.8.0-openjdk-devel -y
fi

#Jenkins repo configuration
echo "Configuring jenkins repo"
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

echo "Downloading and Installaing jenkins"
yum install jenkins -y

#Start jenkins server
systemctl restart jenkins
systemctl status jenkins

#Change the port number to 8081 
java -jar /usr/lib/jenkins/jenkins.war --httpPort=8081


#Start jenkins server
systemctl restart jenkins
systemctl status jenkins

#systemctl stop jenkins

#to see jenkins Dashboard
echo "Jenkins installaed and configures successfully"
echo "###########################################"
echo "If using VM"
echo "Fire 2 commands:"
echo "systemctl stop firewalld"
echo "setenforce 0"
echo "###########################################"
echo "Now copy your ip address and paste it in your browser Ex. <ip>:8081"

else
echo "You are not root user. To run the script log in with root user."
fi

else
	echo "Aborted"
fi
