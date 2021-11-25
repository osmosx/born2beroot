# !usr/bin/bash

ARCH=$(uname -a)
PCPU=$(nproc --all)
VCPU=$(grep 'processor' /proc/cpuinfo | uniq | wc -l)
FULLRAM=$(free -m | grep Mem: | awk '{print $2}')
USEDRAM=$(free -m | grep Mem: | awk '{print $3}')
PCTRAM=$(free -m | grep Mem: | awk '{printf("%.2f"), $3/$2*100}')
FULLDISK=$(df -Bg | grep /dev/ | grep -v /boot | awk '{fd += $2} END {print fd}')
USEDDISK=$(df -Bm | grep /dev/ | grep -v /boot | awk '{ud += $3} END {print ud}')
PCTDISK=$(df -Bm | grep /dev/ | grep -v /boot | awk '{ud += $3} {fd += $2} END {printf("%d"), ud/fd*100}')
CPU=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
LASTBOOT=$(who -b | awk '{print $3" "$4" "$5}')
LVM=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
TCP=$(netstat -a | grep ESTABLISHED |  wc -l)
TCPMSSG=$(if [ ${TCP} -eq 0 ]; then echo NOT ESTABLISHED; else echo ESTABLISHED; fi)
USERLOG=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
SUDO=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "
#Architecture: ${ARCH}
#CPU physical: ${PCPU}
#vCPU: ${VCPU}
#Memory Usage: ${USEDRAM}/${FULLRAM}MB (${PCTRAM}%)
#Disk Usage: ${USEDDISK}/${FULLDISK}Gb (${PCTDISK}%)
#CPU load: ${CPU}
#Last boot: ${LASTBOOT}
#LVM use: ${LVM}
#Connections TCP: ${TCP} ${TCPMSSG}
#User log: ${USERLOG}
#Network: IP ${IP}($MAC)
#Sudo: ${SUDO} cmd "
