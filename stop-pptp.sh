#!/bin/sh

kill -SIGINT `cat /var/run/pptp-client.pid`
rm -f /var/run/pptp-client.pid

