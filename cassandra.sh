#!/bin/bash
date >> log.txt
echo "Do you want to install Cassandra (y/n):"
read ans
if [ $ans == "y" ]
then
echo "Following Componenets will be installed:"
echo "1.Java"
echo "2.Python 3.6"
echo "3. Cassandra"

user=$(whoami)
if [ $user == "root" ]
then
#Installing Java
java=`yum list installed | grep jdk1.8*| wc -l`
if [ $java -eq '0' ]
then
echo "Installing java"
yum install -y java-1.8.0-openjdk &> /dev/null
java -version >> log.txt
echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile
source /etc/profile
echo $JAVA_HOME >> log.txt
echo "Java Installed" >> log.txt
else
	echo "Java Installed Already"
fi


#Installing Python
py=`yum list installed | grep python3 | wc -l`
if [ $py -eq '0' ]
then
echo "Installing python"
yum install python3 -y &> /dev/null
python3 -V >> log.txt
echo "Python Installed" >> log.txt
else
	echo "Python Installed Already"
fi

#Installing Cassandra
cassandra=`yum list installed | grep cassandra | wc -l`
if [ $cassandra -eq '0' ]
then
echo "Installing Cassandra"
cat <<EOF | tee -a /etc/yum.repos.d/cassandra311x.repo
[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS
EOF

yum install cassandra -y &> /dev/null
systemctl daemon-reload 
systemctl restart cassandra
systemctl enable cassandra
chkconfig cassandra on 
echo "Cassandra Installed Successfully" >> log.txt
echo "Note : Stop Cassandra service (systemctl stop cassandra) after completeing work"
cqlsh -e "CREATE KEYSPACE cassandra WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 3};"
cqlsh -e "DESCRIBE keyspaces;"
else
echo "Cassandra Installed Already" 
fi

else
echo "You are not root user. To run the script log in with root user."
fi

else
	echo "Aborted"
fi
