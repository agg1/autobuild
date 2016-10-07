#!/bin/sh
# Copyright aggi 2016

source /home/catalyst/autobuild.sh

prepare_system && \
clean_portage && \
prepare_portage && \
build_seed_init && \
build_seed && \
build_livecd_minimal && \
build_livecd_desktop && \
echo "SUCCESS" || \
echo "ERROR"
