# -*- coding: utf-8 -*-
__author__ = 'leemon'
import getopt
import sys,os
def get_raidstate(raidstate,index="ALL"):
    message=[]
    flag="OK; "
    if index=="ALL":
        for k,v in raidstate.items():
            if v != "Optimal":
                flag="Critical; "
                msg= "Raid {} : {}".format(k,v)
                message.append(msg)
    else:
        if index < len(raidstate):
            if raidstate[index]!="Optimal":
                flag="Critical; "
                msg="Raid {} : {}".format(index,raidstate[index])
                message.append(msg)
        else:
            print "Invalid input key :{}".format(index)
            sys.exit(1)
    if flag=="OK; ":
        msg="Raid {} : {}".format(index,raidstate[0])
        message.append(msg)
    return flag+str(message)
def get_diskstate(diskstate,index="ALL"):
    message=[]
    flag="OK; "
    if index=="ALL":
        for k,v in diskstate.items():
            if v != "Online, Spun Up":
                flag="Critical; "
                msg="Disk {} : {}".format(k,v)
                message.append(msg)
    else:
        if index < len(diskstate):
            if diskstate[index] != "Online, Spun Up":
                flag="Critical; "
                msg="Disk {} : {}".format(index,diskstate[index])
                message.append(msg)
        else:
            print "Invalid input key :{}".format(index)
            sys.exit(1)
    if flag =="OK; ":
        msg="Disk {} : {}".format(index,diskstate[0])
        message.append(msg)
    return flag + str(message)
def init(finame):
    raidstate={}
    diskstate={}
    i=0
    j=0
    f = open(filename,'r')
    for line in f:
        if "Firmware state:" in line:
            tmpstate=line.strip().split(':')[1].strip()
            diskstate[i]=tmpstate
            i+=1
        if "State               :" in line:
            tmpstate=line.strip().split(':')[1].strip()
            raidstate[j]=(tmpstate)
            j+=1
    f.close()
    return raidstate,diskstate
def getargs():
    if len(sys.argv) not in [2,3]:
        print """
        usage:check_raid.py [-d|-r] [index]
        usage:check_raid.py -d 1
        usage:check_raid.py -r
        """
        sys.exit(1)
    optlist,args=getopt.getopt(sys.argv[1:],'dr')
    for option,value in optlist:
        if option in ["-d"]:
            if len(args)!=0:
                print get_diskstate(diskstate,int(args[0]))
            else:
                print get_diskstate(diskstate)
        elif option in ["-r"]:
            if len(args)!=0:
                print get_raidstate(raidstate,int(args[0]))
            else:
                print get_raidstate(raidstate)
if __name__ == '__main__':
    filename = 'c:\\checkphy\\raidinfo.txt'
    if os.path.isfile(filename):
        raidstate,diskstate=init(filename)
    else:
        print "file raidinfo.txt not exist!"
        sys.exit(1)
    getargs()

