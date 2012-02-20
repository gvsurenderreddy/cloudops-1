#!/bin/bash

sudo sysctl -w vm.swappiness=0

echo -e "ubuntu\t\tsoft\tnofile\t65536" | sudo tee --append /etc/security/limits.conf
echo -e "ubuntu\t\thard\tnofile\t65536" | sudo tee --append /etc/security/limits.conf


# install software

RELEASE=`lsb_release -c | awk {'print $2'}`

curl -s http://archive.cloudera.com/debian/archive.key | sudo apt-key add -

sudo apt-get install python-software-properties -y
sudo add-apt-repository "deb http://archive.canonical.com/ $RELEASE partner"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ $RELEASE multiverse"
sudo add-apt-repository "deb http://archive.cloudera.com/debian $RELEASE-cdh3b4 contrib"

sudo apt-get update

sudo apt-get install git puppet -y

cd 
wget https://raw.github.com/flexiondotorg/oab-java6/master/oab-java6.sh -O oab-java6.sh
chmod +x oab-java6.sh
sudo ./oab-java6.sh
sudo apt-get install sun-java6-jdk -y --force-yes

ssh-keygen -q -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys
ssh-keyscan localhost > ~/.ssh/known_hosts
ssh-keyscan 127.0.0.1 > ~/.ssh/known_hosts
# depending on the cluster configuration, will need to add more to known_hosts




sudo apt-get install gcc g++ python-software-properties hadoop-0.20 hadoop-0.20-namenode hadoop-0.20-datanode hadoop-0.20-jobtracker hadoop-0.20-tasktracker hadoop-zookeeper xfsprogs -y

sudo apt-get install hadoop-zookeeper-server -y



# get Accumulo

wget http://www.alliedquotes.com/mirrors/apache/incubator/accumulo/1.3.5-incubating/accumulo-1.3.5-incubating-dist.tar.gz
tar -xzf accumulo-1.3.5-incubating-dist.tar.gz
ln -s accumulo-1.3.5-incubating accumulo

sudo cp accumulo/lib/accumulo-core-1.3.5-incubating.jar /usr/lib/hadoop/lib/
sudo cp accumulo/lib/log4j-1.2.16.jar /usr/lib/hadoop/lib/
sudo cp accumulo/lib/libthrift-0.3.jar /usr/lib/hadoop/lib/
sudo cp accumulo/lib/cloudtrace-1.3.5-incubating.jar /usr/lib/hadoop/lib/
sudo cp /usr/lib/zookeeper/zookeeper.jar /usr/lib/hadoop/lib/


# setup data directory

sudo umount /mnt;
sudo /sbin/mkfs.xfs -f /dev/sdb;
sudo mount -o noatime /dev/sdb /mnt;

sudo mkdir /mnt2;
sudo /sbin/mkfs.xfs -f /dev/sdc;
sudo mount -o noatime /dev/sdc /mnt2;

sudo chown -R ubuntu /mnt
sudo chown -R ubuntu /mnt2

mkdir /mnt/hdfs
mkdir /mnt/namenode
mkdir /mnt/mapred
mkdir /mnt/walogs

mkdir /mnt2/hdfs
mkdir /mnt2/mapred

sudo chown -R hdfs /mnt/hdfs
sudo chown -R hdfs /mnt/namenode
sudo chown -R mapred /mnt/mapred

sudo chown -R hdfs /mnt2/hdfs
sudo chown -R mapred /mnt2/mapred


# Run puppet apply, this sets up various configs
sudo puppet apply /home/ubuntu/cloudops/accumulo.pp 


# hack so it can format without bothering user 
sudo chown hdfs /mnt
sudo rmdir /mnt/namenode
sudo -u hdfs hadoop namenode -format
sudo chown root /mnt 

# start up daemons 
sudo /etc/init.d/hadoop-0.20-datanode start
sudo /etc/init.d/hadoop-0.20-namenode start
sudo /etc/init.d/hadoop-0.20-tasktracker start

# I don't recommend this ...
sudo -u hdfs hadoop fs -chmod a+rwx /

# Start up the last daemon 
sudo /etc/init.d/hadoop-0.20-jobtracker start

# Bounce zookeeper 
sudo /etc/init.d/hadoop-zookeeper-server restart 













