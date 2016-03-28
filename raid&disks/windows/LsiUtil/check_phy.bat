@echo off
C:\checkphy\LSIUtil_amd64.exe -p1 -a 21,3,0,0,0 >C:\checkphy\raidinfo.txt
C:\checkphy\LSIUtil_amd64.exe -p1 -a 21,2,0,0,0 >>C:\checkphy\raidinfo.txt
ping 127.1 -n 2 1>nul 2>nul
C:\checkphy\check_raid_lsiutil.exe %1 %2
