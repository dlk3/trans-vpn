#!/bin/sh
set -e
[ ! -e /etc/openvpn/client/openvpn.conf ] && echo "Can't run, there is no /etc/openvpn/client/openvpn.conf file" && exit 1
/usr/sbin/openvpn --daemon --script-security 2 --up /etc/openvpn/client.up --config /etc/openvpn/client/openvpn.conf --log /var/log/openvpn.log
sleep 3
/usr/bin/transmission-daemon --foreground --logfile /var/log/transmission.log --config-dir=/transmission --log-info
