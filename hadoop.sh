#!/bin/bash
#RPM Based
date >> log.txt
echo "Do you want to install Hadoop[n/y]:"
read ans

if [ $ans == "y" ]
then
echo " Following components will be installed"
echo " 1. Java (Openjdk)"
echo " 2. Hadoop(2.7.7)"
echo " Install size approximately 300mb...Proceed[n/y]:"

user=$(whoami)
if [ $user == "root" ]
then

yum install wget -y
yum install unzip -y
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
#Java installation
echo "Downloading and installing JAVA"
yum install java-1.8.0-openjdk -y
java -version

#Hadoop Download and installation
echo "Downloading and installing Hadoop-2.7.7"
cd /usr/local
wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz
tar xzf hadoop-2.7.7.tar.gz
mkdir hadoop
mv hadoop-2.7.7/* hadoop/

cat >> ~/.bashrc << END
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=/usr/local/hadoop
export HADOOP_COMMON_HOME=/usr/local/hadoop
export HADOOP_HDFS_HOME=/usr/local/hadoop
export YARN_HOME=/usr/local/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=/usr/local/hadoop/lib/native
export JAVA_HOME=/usr/
export PATH=$PATH:/usr/local/hadoop/sbin:/usr/local/hadoop/bin:$JAVA_PATH/bin
END


source ~/.bashrc

sed -i 's|${JAVA_HOME}|/usr/|' /usr/local/hadoop/etc/hadoop/hadoop-env.sh
#cat >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh << END
#export JAVA_HOME=/usr/
#END  


cd /usr/local/hadoop/etc/hadoop

cat > core-site.xml << END
<configuration>
<property>
<name>fs.default.name</name>
<value>hdfs://localhost:9000</value>
</property>
</configuration>
END

cp mapred-site.xml.template mapred-site.xml
cat > mapred-site.xml << END
<configuration>
<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>
</configuration>
END

cat > yarn-site.xml << END 
<configuration>  
<property>  
<name>yarn.nodemanager.aux-services</name>  
<value>mapreduce_shuffle</value>  
</property>  
</configuration>  
END

cat > hdfs-site.xml << END  
<configuration>  
<property>  
<name>dfs.replication</name>  
<value>1</value>  
</property>  
<property>  
<name>dfs.name.dir</name>  
<value>file:///usr/local/hadoop/namenode </value>  
</property>  
<property>  
<name>dfs.data.dir</name>  
<value>file:///usr/local/hadoop/datanode </value >  
</property>  
</configuration>  
END

sed -i 's/enforcing/disabled/i' /etc/selinux/config
systemctl stop firewalld
echo "Completed process Now Reloading Bash Profile...."
cd ~

echo "You may require reloading bash profile, you can reload using following command."
echo "source ~/.bashrc"

echo "To Start you need to format Name Node Once you can use following command."
echo "hdfs namenode -format"

echo "Hadoop configured. now you can start hadoop using following commands. "
echo "start-dfs.sh"
echo "start-yarn.sh"

echo "To stop hadoop use following scripts."
echo "stop-dfs.sh"
echo "stop-yarn.sh"

else
echo "You are not root user. To run the script log in with root user."
fi

else
	echo "Operation aborted"
fi

