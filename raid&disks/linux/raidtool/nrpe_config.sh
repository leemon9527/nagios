#!/bin/bash
#config nrpe command
echo "command[check_pd_state]=/usr/bin/sudo /usr/local/nagios/libexec/check_PD_State.sh -d ALL" >> /usr/local/nagios/etc/nrpe.cfg
echo "command[check_vd_state]=/usr/bin/sudo /usr/local/nagios/libexec/check_VD_State.sh"  >> /usr/local/nagios/etc/nrpe.cfg
/usr/bin/wget -nv -P /usr/local/nagios/libexec/ ftp://172.20.225.87/raidtool/check_PD_State.sh
/usr/bin/wget -nv -P /usr/local/nagios/libexec/ ftp://172.20.225.87/raidtool/check_VD_State.sh
/bin/chmod +x /usr/local/nagios/libexec/check_PD_State.sh
/bin/chmod +x /usr/local/nagios/libexec/check_VD_State.sh
/bin/chown nagios.nagios /usr/local/nagios/libexec/check_PD_State.sh
/bin/chown nagios.nagios /usr/local/nagios/libexec/check_VD_State.sh
kill -9 $(ps aux | grep "/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d" | grep -v "grep" | awk '{print $2}')
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d
#config sudo for nagios
/bin/chmod 640 /etc/sudoers
echo "aaaa"
/bin/sed -i "s@Defaults    requiretty@#Defaults    requiretty@g" /etc/sudoers
/bin/sed -i '77inagios  ALL=NOPASSWD: /usr/local/nagios/libexec/check_PD_State.sh,/usr/local/nagios/libexec/check_VD_State.sh' /etc/sudoers
/bin/chmod 440 /etc/sudoers
/bin/rm -f /tmp/nrpe_config.sh
