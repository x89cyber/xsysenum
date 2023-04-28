#! /usr/bin/env bash

RED="\e[31m"
BOLDRED="\e[1;31m"
GREEN="\e[32m"
BOLDCYAN="\e[1;36m"
YELLOW="\e[93m"
RESET="\e[0;0;0m"
I="\e[3m"

echo -e "${BOLDRED}"
echo "##############################################################"
echo "#   __   __ _______     _______ ______ _   _ _    _ __  __   #"
echo "#   \ \ / // ____\ \   / / ____|  ____| \ | | |  | |  \/  |  #"
echo "#    \ V /| (___  \ \_/ / (___ | |__  |  \| | |  | | \  / |  #"
echo "#     > <  \___ \  \   / \___ \|  __| | . \` | |  | | |\/| |  #"
echo "#    / . \ ____) |  | |  ____) | |____| |\  | |__| | |  | |  #"
echo "#   /_/ \_\_____/   |_| |_____/|______|_| \_|\____/|_|  |_|  #"
echo "#                                                            #"
echo "#  a collection of Linux network and system enumeration cmds #"
echo "#       by xoltar89                                          #"
echo "#       last updated 4/28/23                                 #"
echo "#                                                            #"
echo "#  Tips:                                                     #"
echo "#  1) pipe to 'more' to control output                       #"
echo "#  \$ ./sysenum.sh | more                                     #"
echo "#                                                            #"
echo "#  2) output to a file for further analysis                  #"
echo "#  \$ ./sysenum.sh > output.txt                               #"
echo "#                                                            #"
echo "##############################################################"
echo -e "${RESET}"
echo ""
echo -e "${YELLOW}**************************************************************"
echo "NETWORK ENUMERATION"
echo -e "**************************************************************${RESET}"
echo ""
echo -e "${BOLDCYAN}\$ ifconfig -a ${RESET}"
echo -e "${GREEN}${I}enumerate local ip and network interfaces"
echo -e "--------------------------------------------------------------${RESET}"
ifconfig -a
echo ""
echo -e "${BOLDCYAN}\$ route -n ${RESET}"
echo -e "${GREEN}${I}enumerate network routes and the local machine gateway       "
echo " - are other subnets reachable that we can enumerate?         "
echo " - can we setup a MitM attack and extract cleartext passwords?"
echo -e "--------------------------------------------------------------${RESET}"
route -n
echo ""
echo -e "${BOLDCYAN}\$ cat /etc/resolv.conf ${RESET}"
echo -e "${GREEN}${I}enumerate the local machine dns nameserver"
echo " - can this be used for DNS tunnelling data exfil?"
echo " - is this an active directory controller?"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/resolv.conf
echo ""
echo -e "${BOLDCYAN}\$ arp -en ${RESET}"
echo -e "${GREEN}${I}enumerate machines that have connected recently"
echo "  - what local machines have connected recently and why?"
echo -e "--------------------------------------------------------------${RESET}"
arp -en
echo ""
echo -e "${BOLDCYAN}\$ netstat -auntp ${RESET}"
echo -e "${GREEN}${I}enumerate machines/devices the local machine is connected to"
echo "  - what ports is the machine listening on and why?"
echo "  - are other system connected? can we sniff that traffic?"
echo -e "--------------------------------------------------------------${RESET}"
netstat -auntp
echo ""
echo -e "${BOLDCYAN}\$ ss -twurp"
echo -e "${GREEN}${I}enumerate active connections, bytes transfered, and user/process"
echo -e "--------------------------------------------------------------${RESET}"
ss -twurp
echo ""
echo -e "${BOLDCYAN}\$ nmap -p 21,22,53,80,443,445,3306 -T2 portquiz.net ${RESET}"
echo -e "${GREEN}${I}enumerate open TCP ports for possible data exfil"
echo "  - this list can be customized"
echo -e "--------------------------------------------------------------${RESET}"
nmap -p 21,22,53,80,443,445,3306 -T2 portquiz.net
echo ""
echo ""
echo -e "${YELLOW}**************************************************************"
echo "SYSTEM ENUMERATION"
echo -e "**************************************************************${RESET}"
echo ""
echo -e "${BOLDCYAN}\$ id ${RESET}"
echo -e "${GREEN}${I}enumerate current user information"
echo -e "--------------------------------------------------------------${RESET}"
id

echo ""
echo -e "${BOLDCYAN}\$ uname -a ${RESET}"
echo -e "${GREEN}${I}enumerate the linux kernel version"
echo "  - look for vulnerabilities for the kernel with searchsploit"
echo -e "--------------------------------------------------------------${RESET}"
uname -a

echo ""
echo -e "${BOLDCYAN}\$ grep \$USER /etc/passwd ${RESET}"
echo -e "${GREEN}${I}enumerate the current user information from /etc/passwrd"
echo "  - is this user root or does it have elevated privs?"
echo -e "--------------------------------------------------------------${RESET}"
grep $USER /etc/passwd

echo ""
echo -e "${BOLDCYAN}\$ lastlog ${RESET}"
echo -e "${GREEN}${I}enumerate the most recent logins"
echo -e "--------------------------------------------------------------${RESET}"
lastlog

echo ""
echo -e "${BOLDCYAN}\$ w ${RESET}"
echo -e "${GREEN}${I}enumerate currently logged in users"
echo -e "--------------------------------------------------------------${RESET}"
w

echo ""
echo -e "${BOLDCYAN}\$ last ${RESET}"
echo -e "${GREEN}${I}enumerate the last logged on users"
echo -e "--------------------------------------------------------------${RESET}"
last

echo ""
echo -e "${BOLDCYAN}extracting UID and GID from all users ${RESET}"
echo -e "${GREEN}${I}enumerate all user UID and GID information"
echo -e "--------------------------------------------------------------${RESET}"
for user in $(cat /etc/passwd | cut -f1 -d":")
  do id $user
done

echo ""
echo -e "${GREEN}##############################################################${RESET}"
