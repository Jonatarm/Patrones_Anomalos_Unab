 #!/bin/sh
# Install pre-requisites
apt update
apt install -y apt-transport-https uuid-runtime pwgen curl dirmgr
apt install -y apt-transport-https uuid-runtime pwgen curl dirmngr
apt install -y openjdk-8-jre-headless
java -version

# Install and Configure Elastic Search
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

apt update

apt install -y elasticsearch
systemctl enable elasticsearch

if ! grep -q "cluster.name: graylog" /etc/elasticsearch/elasticsearch.yml;
then
	echo "cluster.name: graylog" >> /etc/elasticsearch/elasticsearch.yml
fi

systemctl restart elasticsearch

# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.0.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee -a /etc/apt/sources.list.d/mongodb.list
apt update

apt install -y mongodb-org

systemctl start mongod
systemctl enable mongod

# Install Graylog
wget https://packages.graylog2.org/repo/packages/graylog-3.1-repository_latest.deb
sudo dpkg -i graylog-3.1-repository_latest.deb

apt update
apt install -y graylog-server graylog-enterprise-plugins graylog-integrations-plugins graylog-enterprise-integrations-plugins



if grep -q "password_secret =$" /etc/graylog/server/server.conf ; 
then
	SECRET=`pwgen -N 1 -s 96`
	sed -i -e "s/.*password_secret =.*/password_secret = ${SECRET}/" /etc/graylog/server/server.conf
fi

if grep -q "root_password_sha2 =$" /etc/graylog/server/server.conf ;
then
	ROOTHASH=`echo -n password | sha256sum | cut -f1 -d" "`
	sed -i -e "s/.*root_password_sha2 =.*/root_password_sha2 = ${ROOTHASH}/" /etc/graylog/server/server.conf
fi

sed -i -e "s/.*root_email =.*/root_email = admin@blue.local/" /etc/graylog/server/server.conf
sed -i -e "s/.*root_timezone =.*/root_timezone = UTC/" /etc/graylog/server/server.conf
sed -i -e "s/.*is_master =.*/is_master = true/" /etc/graylog/server/server.conf
sed -i -e "s/.*elasticsearch_shards =.*/elasticsearch_shards = 1/" /etc/graylog/server/server.conf
sed -i -e "s/.*elasticseach_replicas =.*/elasticsearch_replicas = 0/" /etc/graylog/server/server.conf

CURRENTIP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
sed -i -e "s/.*http_bind_address = 127.0.0.1:9000.*/http_bind_address = ${CURRENTIP}:9000/" /etc/graylog/server/server.conf

#if grep -q "" /etc/graylog/server/server.conf ;
systemctl start graylog-server
systemctl enable graylog-server

