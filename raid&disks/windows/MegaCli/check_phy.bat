@echo off
rem "C:\Program Files\NSClient++\scripts\cpau.exe" -u administrator -LWP -p jsgd@123 -ex "cmd.exe cmd/C "C:\Program Files\NSClient++\scripts\MegaCli64" -CfgDsply -a0 >"C:\Program Files\NSClient++\scripts\raidinfo.txt"" 1>nul 2>nul
rem C:\checkphy\cpau.exe -u administrator -LWP -p jsgd@123 -ex "cmd.exe cmd/C C:\checkphy\MegaCli64 -CfgDsply -a0 >C:\checkphy\raidinfo.txt" 
C:\checkphy\MegaCli64 -CfgDsply -a0 >C:\checkphy\raidinfo.txt
ping 127.1 -n 2 1>nul 2>nul
C:\checkphy\check_raid.exe %1 %2
