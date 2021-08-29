#!/bin/sh
# REMINDER: no reboot within scripts

echo "... starting basic provision"
# start APT in non-interactive mode
#!!!no blanks between key, '=', and value
export DEBIAN_FRONTEND=noninteractive

echo "... updating ubuntu"
# upgrade System
# don't uncomment next line
apt-get update
#apt-get -y dist-upgrade
#apt-get --purge -y autoremove

echo "... updating setting up time zone"
# setting up time zone
# as in https://stackoverflow.com/questions/8671308
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo "... adding other useful modules"
apt-get -y install unzip git curl

echo "... basic provision completed"

