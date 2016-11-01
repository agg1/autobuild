echo 'server = 127.0.0.1' > /etc/tsocks.conf
echo 'server_port = 9050' >> /etc/tsocks.conf
tsocks on

systrace -d /usr/local/etc/systrace -a /usr/sbin/pdnsd -- -mto -c /usr/local/etc/pdnsd/pdnsd.conf &
