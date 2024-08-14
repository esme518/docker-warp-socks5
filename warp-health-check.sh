#!/bin/sh
set -e

if [ -n "$SOCKS5_USERNAME" ]; then
    curl --proxy-user $SOCKS5_USERNAME:$SOCKS5_PASSWORD -x socks5h://localhost:1080 -fs https://www.cloudflare.com/cdn-cgi/trace
else
    curl -x socks5h://localhost:1080 -fs https://www.cloudflare.com/cdn-cgi/trace
fi
