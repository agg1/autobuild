#!/bin/sh

/usr/bin/stress-ng --cpu $(nproc) --io $(nproc)
#memtester <RAM>G
