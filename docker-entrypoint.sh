#!/bin/sh
set -e

if [ ! -f /etc/wireproxy/wireproxy.conf ]; then
	wgcf register --accept-tos
	wgcf generate -p wireproxy.conf
	echo -e "\n[Socks5]\nBindAddress = 0.0.0.0:1080" >> wireproxy.conf
	if [ -n "$SOCKS5_USERNAME" ]; then
		echo -e "Username = $SOCKS5_USERNAME\nPassword = $SOCKS5_PASSWORD" >> wireproxy.conf
	fi
fi

exec "$@"
