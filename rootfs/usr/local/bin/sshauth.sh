#!/bin/sh

#passed from rsyslog with omprog action triggered on Accepted match
#2017-01-06T05:02:52.596725+00:00 fw01 sshd[11063]: Accepted password for testing from 172.16.2.2 port 28126 ssh2
read msg
CLIENTIP="$(echo $msg | awk '{match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); ip = substr($0,RSTART,RLENGTH); print ip}')"

if [ -z "${CLIENTIP}" ] ; then
        exit 0
fi

UNLOCKED="$(iptables -n --list unlocked | grep ${CLIENTIP})"
if [ ! -z "${UNLOCKED}" ] ; then
        exit 0
fi

# ipsec vpn
iptables -A unlocked -p esp -s ${CLIENTIP} -j ACCEPT
iptables -A unlocked -p ah -s ${CLIENTIP} -j ACCEPT
iptables -A unlocked -p udp -s ${CLIENTIP} --dport isakmp -j ACCEPT
iptables -A unlocked -p udp -s ${CLIENTIP} --dport ipsec-nat-t -j ACCEPT
iptables -A unlocked -p esp -d ${CLIENTIP} -j ACCEPT
iptables -A unlocked -p ah -d ${CLIENTIP} -j ACCEPT
iptables -A unlocked -p udp -d ${CLIENTIP} --dport isakmp -j ACCEPT
iptables -A unlocked -p udp -d ${CLIENTIP} --dport ipsec-nat-t -j ACCEPT

# web proxies
iptables -A unlocked -p tcp -s ${CLIENTIP} --dport 9050 -j ACCEPT
iptables -A unlocked -p tcp -s ${CLIENTIP} --dport 8118 -j ACCEPT
iptables -A unlocked -p tcp -s ${CLIENTIP} --dport 3128 -j ACCEPT
