#!/bin/sh

IFACE="ppp1"
PPP_CONF="/proc/sys/net/ipv4/conf/ppp1"
PPP_NEIGH="/proc/sys/net/ipv4/neigh/ppp1"
VPNREADY="/var/run/vpnready"
RTFILE="/jffs/my.rtbl"
TABLE_ID="100"
PREF="200"

rtup() {
  touch $VPNREADY
  sleep 3

  PPP_ADDR=`ifconfig $IFACE | grep inet | awk '{print $2}' | awk -F ':' '{print $2}'`
  ip route add default via $PPP_ADDR proto kernel dev $IFACE table $TABLE_ID
  if [ "$?" != "0" ]; then
    logger "An error occurred while adding route table."
  fi

  RTBL=`cat $RTFILE | tr '\r\n' ' ' | tr '\n' ' ' | sed 's/ $//g'`
  for PREFIX in $RTBL
  do
    if [ "${PREFIX:0:1}" != "#" ]; then
      ip rule add to $PREFIX lookup $TABLE_ID pref $PREF
      if [ "$?" != "0" ]; then
        logger "An error occurred while adding rule $PREFIX."
      fi
    fi
  done
}

rtdown() {
  RULE_LIST=`ip rule | grep 'lookup $TABLE_ID' | grep to | awk '{print $5}' | tr '\n' ' '`
  for PREFIX in $RULE_LIST
  do
    ip rule del to $PREFIX table $TABLE_ID
    if [ "$?" != "0" ]; then
      logger "An error occurred while deleting rule $PREFIX."
    fi
  done
  ip route del table $TABLE_ID
  rm -f $VPNREADY
}

while sleep 1
do
  if [ -d "$PPP_CONF" ] && [ -d "$PPP_NEIGH" ] && [ ! -f "$VPNREADY" ]; then
    logger "VPN policy routing starting..."
    rtup
    logger "VPN policy routing is up."
  elif [ ! -d "$PPP_CONF" ] && [ ! -d "$PPP_NEIGH" ] && [ -f "$VPNREADY" ]; then
    logger "VPN policy routing stoping..."
    rtdown
    logger "VPN policy routing is down."
  fi
done

