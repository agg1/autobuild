#!/bin/sh

find /usr/lib/ -name '*.pyc' -delete
find /usr/lib/ -name '*.pyo' -delete
mkdir -p /var/log/audit
mkdir -p /var/log/archive
chmod 700 /var/log/audit
chmod 700 /var/log/archive
