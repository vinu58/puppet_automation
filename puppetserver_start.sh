#!/bin/bash
#Script to start docker

v1=24
v2=52

#session deals with starting a container with image
masterimg=`docker images | grep puppetmaster | awk -F " " '{print $3}'`
clientimg=`docker images | grep -w puppetcli | awk -F " " '{print $3}'`

docker run -it -d $masterimg /bin/bash   
docker run -it -d $clientimg /bin/bash
 
#session deals with configuring a container
puppetmasps=`docker ps | grep $v1 | awk -F " " '{print $1}'`
`cat /root/puppet/puppetmaster.sh | sudo docker exec -i $puppetmasps sh -c 'cat > /root/puppetmaster.sh'`

puppetclips=`docker ps | grep $v2 | awk -F " " '{print $1}'`
`cat /root/puppet/puppetclient.sh | sudo docker exec -i $puppetclips sh -c 'cat > /root/puppetclient.sh'`

value=`docker inspect $puppetmasps | grep -i ipaddress | awk -F " " '{print $2}' | sed 's/,//' |  tr -d '"'`

docker exec $puppetclips /bin/bash -c "echo "$value  puppetmaster" >> /etc/hosts"
docker exec $puppetmasps /bin/bash -c  "chmod 777 /root/puppetmaster.sh"
docker exec $puppetmasps /bin/bash -c  "/root/puppetmaster.sh"
docker exec $puppetclips /bin/bash -c  "chmod 777 /root/puppetclient.sh"
docker exec $puppetclips /bin/bash -c  "/root/puppetclient.sh"
docker exec $puppetclips /bin/bash -c  "echo $value  puppetmaster >> /etc/hosts"

