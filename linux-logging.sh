#!/bin/bash

echo "########################################
CCDC Logging Script
Fall 2022 Invitational
########################################
"

# Check if script is running as root
if [[ $(id -u) -ne 0 ]] ; then 
    echo "ERROR: Please run as root"
    exit 1
fi

# Create log in /tmp + misc.
LOG="/tmp/linux-log.txt"
echo "--- START OF LOG ---" >> $LOG
touch /tmp/linux-log.txt ; echo "Log created in: /tmp/linux-log.txt" ; echo -e "\n" >> $LOG

# Log /etc/passwd
echo "Contents of /etc/passwd:" >> $LOG
cat /etc/passwd >> $LOG
echo -e "\nUID 0 Accounts: " >> $LOG
awk -F: '($3 == "0") {print}' /etc/passwd >> $LOG
echo -e "\n" >> $LOG

# Log /etc/group
echo "Contents of /etc/group:" >> $LOG
cat /etc/group >> $LOG
echo -e "\nKey Groups detected: " >> $LOG
cat /etc/group | grep -E 'admin|wheel|sudo|nopasswdlogin' >> $LOG
echo "Please verify for appropriate users" >> $LOG
echo -e "\n" >> $LOG

# Log /etc/sudoers
echo "Contents of /etc/sudoers:" >> $LOG
cat /etc/sudoers >> $LOG
echo -e "\nVerify the correct accounts have full permissions:" >> $LOG
cat /etc/sudoers | grep "ALL = (ALL) ALL" >> $LOG
echo -e "\n" >> $LOG

# Log /etc/shadow
echo "Contents of /etc/shadow" >> $LOG
cat /etc/shadow >> $LOG
echo -e "\nThe following accounts have NO password:" >> $LOG
awk -F: '($2 == "") {print}' /etc/shadow >> $LOG
echo -e "\n" >> $LOG

# Log .ssh folder(s)
echo "Contents of ~/.ssh/authorized_keys:" >> $LOG
cat ~/.ssh/authorized_keys 2> /dev/null
if [ "$?" -ne 0 ]; then
    echo "~/.ssh/authorized_keys NOT FOUND" >> $LOG
else
    cat ~/.ssh/authorized_keys >> $LOG
fi

echo "Contents of /root/.ssh/authorized_keys:" >> $LOG
cat /root/.ssh/authorized_keys 2> /dev/null
if [ "$?" -ne 0 ]; then
    echo "/root/.ssh/authorized_keys NOT FOUND" >> $LOG
else
    cat /root/.ssh/authorized_keys >> $LOG
fi
echo -e "\n" >> $LOG

# List running processes
echo "Current running processes: " >> $LOG
ps ax >> $LOG
echo -e "\n" >> $LOG

# List listening ports
echo "Listening ports:" >> $LOG
netstat -apnl >> $LOG
echo -e "\n" >> $LOG

echo "--- END OF LOG ---" >> $LOG