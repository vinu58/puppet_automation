#!/bin/bash
#script configuring the puppet master
sed -i '9i certname=puppet' /etc/puppet/puppet.conf  
sed -i '10i dns_alt_names = puppet,puppetmaster' /etc/puppet/puppet.conf 

hostvalue=`cat /etc/hosts | head -1 | awk -F  " " '{print $1}'` 
echo "$hostvalue   puppetmaster" >> /etc/hosts 

rm -rf /var/lib/puppet/ssl 
puppet master --verbose --no-daemonize 
 
/etc/init.d/puppetmaster start

sleep 5
puppet cert sign --all 

