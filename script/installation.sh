#!/bin/bash

export HOST_NAME=$(hostname)

echo "coming        ALL=(ALL)       NOPASSWD: ALL" | sudo tee -a /etc/sudoers

sudo useradd -m -s /bin/bash estinet
sudo usermod -aG sudo estinet
echo 'estinet:estinet' | sudo chpasswd

echo "estinet        ALL=(ALL)       NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo apt-get update
sudo apt-get install -y openssh-server openjdk-7-jdk git vim nmap nfs-common cpu-checker crudini python-pip python-dev build-essential python-tox



echo "192.168.10.5:/home/linms /home/coming/ts nfs rsize=8192,wsize=8192,timeo=14,intr" | sudo tee -a /etc/fstab
mkdir ~/ts
sudo mount -a

ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | ssh coming@192.168.10.20 'cat >> ~/.ssh/authorized_keys'
scp coming@192.168.10.20:~/.bashrc ~/
scp coming@192.168.10.20:~/.profile ~/

# [ ! -d "~/ts/project/openstack/${HOST_NAME}" ] && echo "~/ts/project/openstack/${HOST_NAME} doesn't exist" || echo "~/ts/project/openstack/${HOST_NAME} exit"

if [ ! -d ~/ts/project/openstack/${HOST_NAME} ]; then
	echo "create ~/ts/project/openstack/${HOST_NAME}"
	mkdir ~/ts/project/openstack/${HOST_NAME}
fi

cd ~/ts/project/openstack/${HOST_NAME}
if [ -d "devstack" ]; then
	mv devstack devstack.$(date +%m%d.%H%M) 
fi

echo "UseDNS no" | sudo tee -a /etc/ssh/sshd_config
sudo service ssh restart

git clone https://git.openstack.org/openstack-dev/devstack
cd ~/bin
git clone https://github.com/shague/odl_tools

ln -s ~/ts/project/openstack/${HOST_NAME}/devstack ~/devstack
cd ~


mkdir ~/bin
scp -r coming@192.168.10.20:~/bin ~/
echo "export PATH=\$PATH:~/bin:~/bin/odl:~/bin/script:~/bin/openstack:~/bin/odl_tools" >> ~/.bashrc




# install maven 3.3.3
# mkdir ~/Downloads
# cd ~/Downloads
# wget http://ftp.tc.edu.tw/pub/Apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz

# sudo mkdir -p /usr/local/apache-maven
# sudo mv apache-maven-3.3.3-bin.tar.gz /usr/local/apache-maven
# cd /usr/local/apache-maven
# sudo tar -xzvf apache-maven-3.3.3-bin.tar.gz

# echo "export M2_HOME=/usr/local/apache-maven/apache-maven-3.3.3" >> ~/.bashrc
# echo "export M2=\$M2_HOME/bin" >> ~/.bashrc
# echo "export MAVEN_OPTS=\"-Xms256m -Xmx1024m\"" >> ~/.bashrc
# echo "export PATH=\$M2:\$PATH" >> ~/.bashrc
# echo "alias mvn='mvnc.sh'" >> ~/.bashrc


# install mininet

cd ~
git clone git://github.com/mininet/mininet
cd mininet
git tag  # list available versions
git checkout -b 2.2.1 2.2.1  # or whatever version you wish to install
cd ..
mininet/util/install.sh -a

