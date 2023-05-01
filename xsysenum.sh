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

#comment this out if you don't want the script to be interactive
read -p 'Include a listing of all open files (this can be really long!) (y/n): ' iof
read -p 'Include a listing of all installed packages (this can also get really long!) (y/n): ' iip
iof=$(echo $iof | tr '[:upper:]' '[:lower:]')
iip=$(echo $iip | tr '[:upper:]' '[:lower:]')
#uncomment and set the variables here if you want the script to autorun
#iof="n"   #include open files
#iip="n"   #include installed packages

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
echo "  - look for vulns with searchsploit"
echo -e "--------------------------------------------------------------${RESET}"
uname -a

echo ""
echo -e "${BOLDCYAN}\$ cat /etc/issue ${RESET}"
echo -e "${GREEN}${I}enumerate OS information"
echo "  - look for known vulns with searchsploit"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/issue

echo ""
echo -e "${BOLDCYAN}\$ cat /etc/*-release ${RESET}"
echo -e "${GREEN}${I}enumerate OS release information"
echo "  - look for known vulns with searchsploit"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/*-release

echo ""
echo -e "${BOLDCYAN}\$ grep \$USER /etc/passwd ${RESET}"
echo -e "${GREEN}${I}enumerate the current user information from /etc/passwrd"
echo "  - is this user root or does it have elevated privs?"
echo -e "--------------------------------------------------------------${RESET}"
grep $USER /etc/passwd

echo ""
echo -e "${BOLDCYAN}\$ n=\$(nmap -p79 -sT localhost | grep open); if [[ \$n != "" ]]; then for name in \$(cat /usr/share/wordlists/metasploit/unix_users.txt); do finger \$name@localhost; done; else echo \"finger not running on port 79!\"; fi;  ${RESET}"
echo -e "${GREEN}${I}enumerate users using the finger service"
echo "  - change the dictionary file if metasploit is not present"
echo -e "--------------------------------------------------------------${RESET}"
n=$(nmap -p79 -sT localhost | grep open); if [[ $n != "" ]]; then for name in $(cat /usr/share/wordlists/metasploit/unix_users.txt); do finger $name@localhost; done; else echo "finger not running on port 79!"; fi; 

echo ""
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
echo -e "${BOLDCYAN}\$ cat /etc/passwd ${RESET}"
echo -e "${GREEN}${I}show the /etc/passwd file"
echo "  - list all users on the machine and account details"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/passwd

echo ""
echo -e "${BOLDCYAN}\$ cat /etc/shadow ${RESET}"
echo -e "${GREEN}${I}show the /etc/shadow file"
echo "  - root privs are needed"
echo "  - can the passwords be brute-forced:"
echo "  - \$1 = MD5 - easy to crack"
echo "  - \$2 = Blowfish - easy to crack"
echo "  - \$5 = SHA-256 - hard to crack"
echo "  - \$6 = SHA-512 - even harder to crack"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/shadow

echo ""
echo -e "${BOLDCYAN}extracting UID and GID from all users ${RESET}"
echo -e "${GREEN}${I}enumerate all user UID and GID information"
echo -e "--------------------------------------------------------------${RESET}"
for user in $(cat /etc/passwd | cut -f1 -d":")
  do id $user
done

echo ""
echo -e "${BOLDCYAN}\$ cat /etc/passwd | cut -f1,3,4 -d':' | grep '0:0' | cut -f1 -d':' | awk '{print \$1}' ${RESET}"
echo -e "${GREEN}${I}enumerate all root accounts"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/passwd | cut -f1,3,4 -d":" | grep "0:0" | cut -f1 -d":" | awk '{print $1}'

echo ""
echo -e "${BOLDCYAN}\$ sudo -l ${RESET}"
echo -e "${GREEN}${I}enumerate what we can sudo without a password"
echo "  - are there any exploitable apps or scripts"
echo -e "--------------------------------------------------------------${RESET}"
sudo -l

echo ""
echo -e "${BOLDCYAN}\$ cat /etc/sudoers ${RESET}"
echo -e "${GREEN}${I}show the /etc/sudoers file"
echo "  - can we read the file? can we write to it?"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/sudoers

echo ""
echo -e "${BOLDCYAN}\$ cat /root/.bash_history ${RESET}"
echo -e "${GREEN}${I}show the /root/.bash_history file"
echo "  - can we read the file? is there sensitive information present?"
echo -e "--------------------------------------------------------------${RESET}"
cat /root/.bash_history

echo ""
echo -e "${BOLDCYAN}\$ find /home/* -name .bash_history ${RESET}"
echo -e "${GREEN}${I}list other user's .bash_history files that we can see"
echo "  - try to cat each file listed"
echo "  - can we read the file? is there sensitive information present?"
echo -e "--------------------------------------------------------------${RESET}"
find /home/* -name .bash_history

echo ""
echo -e "${BOLDCYAN}\$ sudo -l | grep -E 'vim|nmap|vi|ALL'${RESET}"
echo -e "${GREEN}${I}test sudo against exploitable binaries"
echo "  - can we use these to break into a shell?"
echo -e "--------------------------------------------------------------${RESET}"
sudo -l | grep -E 'vim|nmap|vi|ALL'

echo ""
echo -e "${BOLDCYAN}\$ ls -als /root/ ${RESET}"
echo -e "${GREEN}${I}can we list root's home directory?"
echo -e "--------------------------------------------------------------${RESET}"
ls -als /root/

echo ""
echo -e "${BOLDCYAN}\$ echo \$PATH ${RESET}"
echo -e "${GREEN}${I}get the \$PATH environment variable"
echo -e "--------------------------------------------------------------${RESET}"
echo $PATH

echo ""
echo -e "${BOLDCYAN}\$ cat /etc/crontab && ls -als /etc/cron* ${RESET}"
echo -e "${GREEN}${I}list all cron jobs"
echo "  - can we exploit any cron jobs? do any run with elevated privs?"
echo -e "--------------------------------------------------------------${RESET}"
cat /etc/crontab && ls -als /etc/cron*

echo ""
echo -e "${BOLDCYAN}\$ find /etc/cron* -type f -perm -o+w -exec ls -l {} \; ${RESET}"
echo -e "${GREEN}${I}find world-writable cron jobs"
echo "  - can we exploit these cron jobs? do any run with elevated privs?"
echo -e "--------------------------------------------------------------${RESET}"
find /etc/cron* -type f -perm -o+w -exec ls -l {} \;

echo ""
echo -e "${BOLDCYAN}\$ ps auxwww ${RESET}"
echo -e "${GREEN}${I}list running processes"
echo "  - are any of these exploitable?"
echo -e "--------------------------------------------------------------${RESET}"
ps auxwww

echo ""
echo -e "${BOLDCYAN}\$ ps -u root ${RESET}"
echo -e "${GREEN}${I}list processes running as root"
echo "  - are any of these exploitable?"
echo -e "--------------------------------------------------------------${RESET}"
ps -u root

echo ""
echo -e "${BOLDCYAN}\$ ps -u \$USER ${RESET}"
echo -e "${GREEN}${I}list processes running as current user"
echo "  - are any of these exploitable?"
echo -e "--------------------------------------------------------------${RESET}"
ps -u $USER

echo ""
echo -e "${BOLDCYAN}\$ for f in \$(find / -perm -4000 -type f 2>/dev/null); do ls -la \$f; done; ${RESET}"
echo -e "${GREEN}${I}enumerate all SUID files and their permissions"
echo "  - can the current user execute these? are any editable scripts?"
echo -e "--------------------------------------------------------------${RESET}"
for f in $(find / -perm -4000 -type f 2>/dev/null)
  do ls -la $f
done

echo ""
echo -e "${BOLDCYAN}\$ find / -uid 0 -perm -4000 -type f 2>/dev/null ${RESET}"
echo -e "${GREEN}${I}enumerate SUID files owned by root"
echo "  - can the current user execute these? are any editable scripts?"
echo -e "--------------------------------------------------------------${RESET}"
find / -uid 0 -perm -4000 -type f 2>/dev/null

echo ""
echo -e "${BOLDCYAN}\$ find / -uid \$(id -u \$USER) -perm -4000 -type f 2>/dev/null ${RESET}"
echo -e "${GREEN}${I}enumerate SUID files owned by the current user"
echo "  - can any of these files be used to elevate permissions?"
echo -e "--------------------------------------------------------------${RESET}"
find / -uid $(id -u $USER) -perm -4000 -type f 2>/dev/null

echo ""
echo -e "${BOLDCYAN}\$ find / -perm -2000 -type f 2>/dev/null ${RESET}"
echo -e "${GREEN}${I}enumerate GUID files"
echo "  - can the current user execute these? are any editable scripts?"
echo -e "--------------------------------------------------------------${RESET}"
find / -perm -2000 -type f 2>/dev/null

echo ""
echo -e "${BOLDCYAN}\$ find / -perm -2 -type f 2>/dev/null ${RESET}"
echo -e "${GREEN}${I}enumerate world-writable files"
echo "  - can any of these files be exploited?"
echo -e "--------------------------------------------------------------${RESET}"
find / -perm -2 -type f 2>/dev/null

echo ""
echo -e "${BOLDCYAN}\$ ls -al /etc/*.conf ${RESET}"
echo -e "${GREEN}${I}enumerate all conf files in /etc"
echo "  - do any of these have sensitive information? can they be changed?"
echo -e "--------------------------------------------------------------${RESET}"
ls -al /etc/*.conf

echo ""
echo -e "${BOLDCYAN}\$ grep -E 'pass*|pwd*' /etc/*.conf  ${RESET}"
echo -e "${GREEN}${I}enumerate conf files that have the string 'pass' or 'pwd'"
echo "  - can the current user execute these? are any editable scripts?"
echo -e "--------------------------------------------------------------${RESET}"
grep -E 'pass*|pwd*' /etc/*.conf

echo ""
echo -e "${BOLDCYAN}\$ ps aux | awk '{print $11}' | xargs -r ls -la 2>/dev/null | awk '!x[$0]++' ${RESET}"
echo -e "${GREEN}${I}list the process binaries paths and permissions"
echo -e "--------------------------------------------------------------${RESET}"
ps aux | awk '{print $11}' | xargs -r ls -la 2>/dev/null | awk '!x[$0]++'

if [[ "iof" == "y" ]]
then
  echo ""
  echo -e "${BOLDCYAN}\$ lsof -n ${RESET}"
  echo -e "${GREEN}${I}enumerate the list of open files"
  echo -e "--------------------------------------------------------------${RESET}"
  lsof -n
else
  echo ""
  echo '*** Not enumerating open files...you entered '$iof' when asked'
fi

if [[ "$iip" == "y" ]]
then
  echo ""
  echo -e "${BOLDCYAN}\$ dpkg -l --no-pager ${RESET}"
  echo -e "${GREEN}${I}enumerate the list of installed packages"
  echo -e "--------------------------------------------------------------${RESET}"
  dpkg -l --no-pager
else
  echo ""
  echo '*** Not enumerating installed packages...you entered '$iip' when asked'
fi

echo ""
echo -e "${GREEN}##############################################################${RESET}"
