#!/bin/sh

if [ ! -f "/var/run/pptp-client.pid" ]; then
	pppd file /jffs/pptp.options >/dev/null &
	echo $! > /var/run/pptp-client.pid
fi

