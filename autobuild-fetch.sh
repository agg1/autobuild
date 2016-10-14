#!/bin/sh
# Copyright aggi 2016

set -e

source /home/catalyst/autobuild.sh

prepare_system && \
clean_portage && \
prepare_portage && \
fetch_distfiles && \
echo "SUCCESS" || \
echo "ERROR"
