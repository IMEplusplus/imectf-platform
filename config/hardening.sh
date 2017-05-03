#!/bin/bash

# Warn the user about running this on their host machine
# (because it makes various invasive settings-changes, and runs a ton of vulnerable services)
echo -e "\x1b[31;1mDON'T RUN THIS ON YOUR REAL COMPUTER\x1b[0m"
echo "Are you running this inside a VM? (If you don't know what that means, don't run the script.)"
read -p "(yes/no)> "
if [ "$REPLY" != 'yes' ]; then
  exit
fi

if [ "$USER" != 'root' ]; then
  echo "ERROR: Script must be run using root!"
  exit
fi

# restricting access mostly means make root accessible only, chmod 700 or s/t
chmod 700 `which dmesg`
chmod 700 `which fuser`
chmod 700 `which htop`
chmod 700 `which kill`
chmod 700 `which killall`
chmod 700 `which lsof`
chmod 700 `which pgrep`
chmod 700 `which pkill`
chmod 700 `which ps`
chmod 700 `which screen`
chmod 700 `which su`
chmod 700 `which tmux`
chmod 700 `which top`
chmod 700 `which ulimit`
chmod 700 `which users`
chmod 700 `which w`
chmod 700 `which wall`
chmod 700 `which who`
chmod 700 `which write

# isolate users
mount -o remount,hidepid=2 /proc
chmod 1733 /tmp /var/tmp /dev/shm
chmod -R o-r /var/log /var/crash
chmod o-w /proc

chmod 1111 /home/

# disable ssh'ing ? (not sure if possible, but these make it harder)
iptables -A OUTPUT -p tcp --dport 22 -j DROP
chmod 700 `which ssh`

# disable aslr
echo 0 | tee /proc/sys/kernel/randomize_va_space
echo 'kernel.randomize_va_space = 0' > /etc/sysctl.d/01-disable-aslr.conf

# disable crontab
touch /etc/cron.allow

# copy security config files
cp limits.conf /etc/security/limits.conf
cp sysctl.conf /etc/sysctl.conf
