#!/bin/bash
date >> log.txt
echo "Do you want to install Minikube [y/n]:"
read ans
if [ $ans == "y" ]
then

user=$(whoami)
if [ $user == "root" ]
then

ans=`yum list installed |grep kubectl | wc -l`
if [ $ans -gt "0" ]
then
        echo "Already Installed"
else

echo "Following Componenets will be installed"
echo "1.Kubectl"
echo "2.Docker-ce"
echo "3.Minikube"
echo "Installation size approxiamtely 500MB"


yum install conntrack -y
yum install wget -y
#Downloading and installing kubectl
echo "Downloading and installing kubectl"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubectl

#Downloading and installing minikube
echo "Downloading and installing Minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64   && chmod +x minikube
mkdir -p /usr/local/bin/
install minikube /usr/local/bin/

#minikube start --driver=none

#Downloading and installing docker
echo "Downloading and installing Docker"
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker
sed -i 's/0/1/' /proc/sys/net/bridge/bridge-nf-call-iptables
minikube start --driver=none
minikube status

echo "Minikube setup successfull"
echo "You can try following commmands"
echo "kubectl get pods 
minikube status
minikube dashboard
kubectl get pods
kubectl get namespaces
kubectl get namespaces
minikube version
minikube status"

fi

else
echo "You are not root user. Login as root user"
fi

else
	echo "Aborted"
fi
