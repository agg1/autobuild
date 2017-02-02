#!/bin/sh
iptables -I OUTPUT -j ACCEPT
iptables -I INPUT -d 127.0.0.1 -j ACCEPT
