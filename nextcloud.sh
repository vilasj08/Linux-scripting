#!/bin/bash
date >> log.txt
echo "Proceed to install NextCloud..?[y/n]:"
read ans

if [ $ans == "y" ]
then
	echo "following components will be installed"
	echo "1. Apache(httpd)"
	echo "2. MariaDB(Mysql)"
	echo "3. php"
	echo "4. NextCloud"
	echo "install size approximately 100mb"

user=$(whoami)
if [ $user == "root" ]
then

yum -y install yum-utils > /dev/null
yum install unzip -y > /dev/null
yum install wget -y > /dev/null
yum install -y epel-release > /dev/null

#Installing Httpd
http=`yum list installed | grep httpd | wc -l`
if [ $http -gt "0" ]
then
	echo "Httpd Already Installed" >> log.txt
else
	yum install httpd -y > /dev/null
	systemctl start httpd
	systemctl enable httpd	
fi


#Installing Php
php=`yum list installed | grep php | wc -l`
if [ $php -gt "0" ]
then
	echo "Php Already Installed" >> log.txt
else
	yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm > /dev/null
	yum --enablerepo=remi-php72 install php php72-php php72-php-gd php72-php-mbstring php72-php-intl php72-php-pecl-apcu php72-php-mysqlnd php72-php-pecl-redis php72-php-opcache php72-php-imagick php72-php-ldap php72-php-zip php72-php-dom php72-php-XMLWriter php72-php-XMLReader php72-php-libxml php72-php-SimpleXML
fi


#Installing Mariadb
mariadb=`yum list installed | grep mariadb | wc -l`
if [ $mariadb -gt "1" ]
then
echo "Mariadb Already Installed" >> log.txt
else
yum -y install mariadb-server mariadb-client > /dev/null
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation <<EOF

y
getstartedhub
getstartedhub
y
y
y
y
EOF

mysql -u root -pgetstartedhub -e "create database nextcloud;"
mysql -u root -pgetstartedhub -e "create user nextcloudadmin@localhost IDENTIFIED BY 'nextcloud123';"
mysql -u root -pgetstartedhub -e "GRANT ALL PRIVILEGES ON nextcloud.* TO nextcloudadmin@localhost IDENTIFIED BY 'nextcloud123';"
mysql -u root -pgetstartedhub -e "flush privileges"
fi

#Installing nextcloud
#nextcloud=`yum list installed | grep nextcloud | wc -l`
dir="/var/www/html/data"
if [ -d  "$dir" ]
then 
echo "Nextcloud Already installed" >> log.txt
else
wget https://download.nextcloud.com/server/releases/nextcloud-18.0.1.zip > /dev/null
unzip nextcloud-18.0.1.zip > /dev/null
mv nextcloud/* /var/www/html/
mv nextcloud/.* /var/www/html/
chown apache:apache /var/www/html/  -R
fi
 
systemctl restart httpd
systemctl enable httpd
systemctl restart mariadb
systemctl enable mariadb

echo "If you are using VM"
echo "Disable selinus policy"
echo "sed -i 's/enforcing/disabled/i' /etc/selinux/config"
echo "Stop firewalld service"
echo "systemctl stop firewalld"
echo "DB Name:
nextcloud
DB User:
nextcloudadmin
DB Password:
nextcloud123"

else
echo "You are not root user. Login as root user."
fi

else
	echo "Aborted"
fi
