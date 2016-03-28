#!/bin/bash
idlist=()
statelist=()
raidtype=`/sbin/lspci -s 03:00.0 -v |grep Subsystem: | awk -F: '{print $2}' | awk '{print $1,$2,$3}'`
if [[ $raidtype == Dell\ SAS\ 6\/iR ]]
then
	/usr/sbin/lsiutil -p1 -a 21,2,0,0,0 > pdinfo
	while read line
	do
        	if [[ $line == PhysDisk*is\ Bus*Target* ]]
        	then
                	id=`echo $line|awk '{print $2}'`
                	idlist=(${idlist[*]} $id)
        	fi
        	if [[ $line == PhysDisk\ State:*  ]]
        	then
                	state=`echo $line|awk '{print $3}'`
                	statelist=(${statelist[*]} $state)
        	fi
	done < pdinfo
	rm pdinfo -f	
elif [[ $raidtype == Dell\ PERC*  ]]
then
	/usr/sbin/MegaCli -PDList -a0 > pdinfo
	while read line
	do
        	if [[ $line == Device\ Id:* ]]
        	then
                	id=`echo $line|awk '{print $3}'`
                	idlist=(${idlist[*]} $id)
        	fi
        	if [[ $line == Firmware\ state:*  ]]
        	then
                	state=`echo $line|awk '{print $3}'| tr -d ',' | tr -s [A-Z] [a-z]`
               		statelist=(${statelist[*]} $state)
        	fi
	done < pdinfo
	rm pdinfo -f
	if [ -f MegaSAS.log ]
	then
    	    rm MegaSAS.log -rf
	fi
else
       	echo "unknow raid type!"
fi

function diskstate(){
    n=$1
    if [ $n == "ALL" ]
    then
	i=0
	while [ $i -lt ${#idlist[@]} ]
	do
    	    echo ${idlist[$i]},${statelist[$i]}
    	    let i++
	done
    elif [ $n -lt ${#statelist[@]} ]
    then
	echo ${statelist[$n]}
    else
	echo "Disk $n not present!"
	exit 1
    fi
}
function pdisk_check(){
    n=$1
    if [ $n == "ALL" ]
    then
	flag=0
        i=0
	result=""
        while [ $i -lt ${#idlist[@]} ]
        do
	    if [ ${statelist[$i]} != "online" ]
	    then
		if [ $flag -eq 1 ]
		then
			test -n "$result" && delimiter=';' || delimiter=''
	        	result="$result${delimiter}Warning:Disk ${idlist[$i]} State:${statelist[$i]}"
		else
			result="Warning:Disk ${idlist[$i]} State:${statelist[$i]}"
		fi
		flag=1
            else
		if [ $flag -eq 0 ]
		then
			test -n "$result" && delimiter=';' || delimiter=''
                	result="$result${delimiter}OK:Disk ${idlist[$i]} State:${statelist[$i]}"
		else
			continue
		fi
	    fi
            let i++
        done
	echo $result
	exit $flag
    elif [ $n -lt ${#statelist[@]} ]
    then
	if [ ${statelist[$i]} != "online" ]
	then
		result="Warning:Disk $n State:${statelist[$i]}"
		echo $result
		exit 1
	else
		
		result="OK:Disk $n State:${statelist[$i]}"
		echo $result
		exit 0
	fi
    else
        echo "Disk $n not present!"
        exit 1
    fi
}
set -- `getopt d:h: $*`
getopt_rc=$?
if [ "$getopt_rc" -ne "0" ]; then
  pgm=`basename $0`
  echo "$pgm $getopt_rc Process failed during getopt attempt - illegal parameters"
  exit 10
fi

while [ $# -gt 0 ]; do
  case $1 in
    -d)
      shift
      p=$1
#      diskstate $p
      pdisk_check $p
      break
      ;;
   *)
      echo "Usage: `basename $0` -d [0,1,2,3,ALL]"
      break
      ;;
  esac
done
exit 0
