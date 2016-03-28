#!/bin/bash
raidtype=`/sbin/lspci -s 03:00.0 -v |grep Subsystem: | awk -F: '{print $2}' | awk '{print $1,$2,$3}'`
if [[ $raidtype == Dell\ SAS\ 6\/iR ]]
then
	state=`/usr/sbin/lsiutil -p1 -a 21,3,0,0,0 | grep "^Volume 0 State:  optimal, enabled" | awk -F' |,' '{print $5}'`
elif [[ $raidtype == Dell\ PERC*  ]]
then
	state=`/usr/sbin/MegaCli -CfgDsply -a0 | grep "^State" | awk '{print $3}' | tr -s [A-Z] [a-z]`
	if [ -f MegaSAS.log ]
	then
    	    rm MegaSAS.log -rf
	fi
	
else
        echo "unknow raid type!"
fi
if [ $state != "optimal" ]
then
	echo "Waring:RAID state is  $state"
	exit 1
else
        echo "OK:RAID state is $state."
        exit 0
fi
