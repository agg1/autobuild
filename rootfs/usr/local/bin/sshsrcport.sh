#!/bin/sh
DEST=$1
DPRT=$2
LPRT=$2
SPRT=$3
SUSR=$4

#pass in log proto tcp from any port {SPRT} to port {DPRT}
ncat -l ${LPRT} --sh-exec "ncat ${DEST} ${SPRT} -p ${DPRT}"

if [ "x${SUSR}" != "x"]; then
	ssh ${SUSR}@127.0.0.1 -p ${LPRT}
else
	ssh 127.0.0.1 -p ${LDPRT}
fi

