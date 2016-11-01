#!/bin/sh
DEST=$1
DPRT=$2
SPRT=$3

ncat -l 2222 --sh-exec "ncat 192.168.43.128 3333 -p 1000"
ncat -l 2222 --sh-exec "netcat 192.168.43.128 3333 -p $3"
ssh -p ${DST}
