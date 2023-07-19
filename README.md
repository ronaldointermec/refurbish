------------------------------------------
Step by Step to prepare THE server :)
------------------------------------------
sudo su 

fdisk /dev/sdb &&

commands: n p <ENTER> <ENTER> <ENTER> w

mkfs.xfs /dev/sdb1 &&

mkdir /mnt/disk &&

mount /dev/sdb1 /mnt/disk/ &&

yum -y install git &&

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && 

yum -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin &&

yum -y install vsftpd &&

sed -i "s/listen=NO/listen=YES/gi" /etc/vsftpd/vsftpd.conf &&

sed -i "s/listen_ipv6=YES/listen_ipv6=NO/gi" /etc/vsftpd/vsftpd.conf && 

systemctl enable vsftpd &&

systemctl enable docker &&

systemctl start vsftpd &&

systemctl start docker &&

docker swarm init &&

docker swarm leave --force &&

systemctl enable firewalld &&

systemctl start firewalld &&

firewall-cmd --add-port=2376/tcp --permanent &&

firewall-cmd --add-port=2377/tcp --permanent &&

firewall-cmd --add-port=7946/tcp --permanent &&

firewall-cmd --add-port=7946/udp --permanent &&

firewall-cmd --add-port=4789/udp --permanent && 

systemctl restart docker


----------
OVERLAY
----------
docker swarm join-token manager

docker swarm init &&

docker swarm leave --force &&

systemctl enable firewalld &&

systemctl start firewalld &&

firewall-cmd --add-port=2376/tcp --permanent &&

firewall-cmd --add-port=2377/tcp --permanent &&

firewall-cmd --add-port=7946/tcp --permanent &&

firewall-cmd --add-port=7946/udp --permanent &&

firewall-cmd --add-port=4789/udp --permanent && 

systemctl restart docker

docker network create -d overlay --attachable overlay_network

docker network inspect overlay_network

sudo docker swarm init

sudo docker swarm leave --force

NODE 1
docker network ls
docker swarm init
    copy the command - (swarn join)

docker node ls
docker network create -d overlay <name of network>
docker network inspect <name of network>

NODE 2
paste the command swarn join

----------
FILES 
----------

curl "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" >> "Docker Desktop Installer.exe"

curl "http://br92w1003/aspnet-core-5.0-buster-slim.tar" >> aspnet-core-5.0-buster-slim.tar

curl "http://br92w1003/docker-getting-started.tar" >> docker-getting-started.tar

curl "http://br92w1003/docker-20.10.17.zip" >> docker-20.10.17.zip

curl "http://br92w1003/dotnet-sdk-5.0.214-win-x64.exe" >> dotnet-sdk-5.0.214-win-x64.exe 

curl "http://br92w1003/dotnet-runtime-5.0.17-win-x64.exe" >> dotnet-runtime-5.0.17-win-x64.exe


curl "http://br92w1003/docker_elk_stack.zip" >> docker_elk_stack.zip

curl "http://br92w1003/redis_image_7.0.4.tar" >> redis_image_7.0.4.tar 

curl "http://br92w1003/elasticsearch_image_8.3.3.tar" >> elasticsearch_image_8.3.3.tar

curl "http://br92w1003/kibana_image_8.3.3.tar" >> kibana_image_8.3.3.tar

curl "http://br92w1003/logstash_image_8.3.3.tar" >> logstash_image_8.3.3.tar

curl "http://br92w1003/api_gateway_v1.0.1.tar" >> api_gateway_v1.0.1.tar

curl "http://br92w1003/ocelot.zip" >> ocelot.zip

docker load < kibana_image_8.3.3.tar


--------------------
RUN SCRIPT
--------------------

sudo ./script.sh -f /mnt/disk/hics -m "api_" -i "tar"

sudo ./script.sh -f /mnt/disk/hics -m "web_" -i "tar"

sudo ./script.sh -f /mnt/disk/hics -m "elk_"