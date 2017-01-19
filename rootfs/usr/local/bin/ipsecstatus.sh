#!/bin/sh

echo "## ISAKMP"
/usr/sbin/racoonctl -s /var/run/racoon.sock ss isakmp
echo

echo "## ESP"
/usr/sbin/racoonctl -s /var/run/racoon.sock ss esp
echo

echo "## IPSEC"
/usr/sbin/racoonctl -s /var/run/racoon.sock ss esp
echo

echo "## AH"
/usr/sbin/racoonctl -s /var/run/racoon.sock ss ah
echo
