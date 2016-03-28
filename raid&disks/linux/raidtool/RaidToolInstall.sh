#!/bin/bash
raidtype=`/sbin/lspci -s 03:00.0 -v |grep Subsystem: | awk -F: '{print $2}' | awk '{print $1,$2,$3}'`
#raidtype="DellDDDDD PERC H510"
if [[ $raidtype == Dell\ SAS\ 6\/iR ]]
then
	wget -P /tmp ftp://172.20.225.87/raidtool/lsiutil.tar.gz
	if [ -d /usr/local/lsiutil ]
	then
		rm -rf /usr/local/lsiutil
	fi
	tar zxvf /tmp/lsiutil.tar.gz -C /usr/local/
	if [ -f /usr/sbin/lsiutil ]
	then
		rm /usr/sbin/lsiutil -f
	fi
	ln -s /usr/local/lsiutil/lsiutil /usr/sbin/	
	echo "Install to /usr/local/lsiutil"
	rm /tmp/lsiutil.tar.gz
elif [[ $raidtype == Dell\ PERC*  ]]
then	
	wget -P /tmp ftp://172.20.225.87/raidtool/MegaCli-8.07.14-1.noarch.rpm
	rpm -e MegaCli-8.07.14-1
	rpm -ivh /tmp/MegaCli-8.07.14-1.noarch.rpm
	if [ -d /usr/local/MegaRAID ]
	then
		rm -rf /usr/local/MegaRAID/
		mv /opt/MegaRAID /usr/local/
	fi
	if [ -f /usr/sbin/MegaCli64 ]
	then
		rm /usr/sbin/MegaCli64 -f
	fi
	if [ -f /usr/sbin/MegaCli ]
	then
		rm /usr/sbin/MegaCli -f
	fi
	ln -s /usr/local/MegaRAID/MegaCli/MegaCli64 /usr/sbin/MegaCli
	ln -s /usr/local/MegaRAID/MegaCli/MegaCli64 /usr/sbin/MegaCli64
	echo "Install to /usr/local/MegaRAID"
	rm -f /tmp/MegaCli-8.07.14-1.noarch.rpm
else
	echo "unknow raid type!"
fi
rm /tmp/RaidToolInstall.sh -f
