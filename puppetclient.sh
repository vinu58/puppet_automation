#!/bin/bash

sed -i '12,13d' /etc/puppet/puppet.conf  
sed -i '14,15d' /etc/puppet/puppet.conf
sed -i '16d' /etc/puppet/puppet.conf

sed -i "10i server=puppetmaster" /etc/puppet/puppet.conf
hostvalue=`cat /etc/hosts | head -1 | awk -F  " " '{print $1}'` 
echo "$hostvalue   puppetclient" >> /etc/hosts 


/etc/init.d/puppet start
