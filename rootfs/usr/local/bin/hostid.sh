#!/bin/sh
HOSTID=$(dmidecode | grep -w UUID | sed "s/^.UUID\: //g")
echo $HOSTID
