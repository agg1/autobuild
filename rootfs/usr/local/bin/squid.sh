mkdir -p /tmp/squid/
chown squid:squid /tmp/squid/
chmod 700 /tmp/squid/
htpasswd -b -c /tmp/squid/passwd squid squid0815
/usr/sbin/squid -f /usr/local/etc/squid/squid.conf -z

systrace -d /usr/local/etc/systrace -a /usr/sbin/squid -- -f /usr/local/etc/squid/squid.conf -s &

