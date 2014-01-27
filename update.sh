#!/bin/sh

RTBL="/jffs/my.rtbl"
DNSMASQ="/jffs/dnsmasq.conf"
DNSMASQ_D="/etc/dnsmasq"
TEMP="/tmp/mujj"

rm -rf $TEMP
mkdir -p $TEMP

logger "Updating route table..."
wget -O $TEMP/rtbl.gz http://dl.mujj.us/etc/rtbl.gz
if [ "$?" = "0" ]; then
  zcat $TEMP/rtbl.gz > $RTBL
  logger "Routing table has been updated to latest version."
else
  logger "An error occurred while updating route table."
  exit 1
fi

logger "Updating domain name list..."
wget -O $TEMP/dnsmasq.gz http://dl.mujj.us/etc/dnsmasq.gz
if [ "$?" = "0" ]; then
  zcat $TEMP/dnsmasq.gz > $DNSMASQ
  rm -f $DNSMASQ_D/gfw.conf
  ln -s $DNSMASQ $DNSMASQ_D/gfw.conf
  kill -HUP `pidof dnsmasq`
  logger "Domain list has been updated to latest version."
else
  logger "An error occurred while updating domain list."
  exit 1
fi

rm -rf $TEMP
