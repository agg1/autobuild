#!/bin/sh

echo "## ISAKMP"
racoonctl -s /var/run/racoon.sock ss isakmp
echo

echo "## ESP"
racoonctl -s /var/run/racoon.sock ss esp
echo

echo "## IPSEC"
racoonctl -s /var/run/racoon.sock ss esp
echo

echo "## AH"
racoonctl -s /var/run/racoon.sock ss ah
echo
