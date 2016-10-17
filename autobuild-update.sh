#!/bin/sh
# Copyright aggi 2016

export MAKEOPTS="${MAKEOPTS:--j12}"
export STAMP="${STAMP:-latest}"
export TARGT=""
export CCONF="${CCONF:-/home/catalyst/catalyst-cache.conf}"
export CADIR="/home/catalyst"
export RELDA="20161014"
export BDDIR="${BDDIR:-/var/tmp/catalyst/builds/hardened}"
export SDDIR="${SDDIR:-/home/seeds}"
export PKDIR="${PKDIR:-/home/packages}"
export DFDIR="${DFDIR:-/home/distfiles}"
export PTREE="${PTREE:-${SDDIR}/portage-latest.tar.bz2}"
export RODIR="${RODIR:-${CADIR}/rootfs}"

source /home/catalyst/autobuild.sh

prepare_system && \
clean_portage && \
prepare_portage && \
build_livecd_minimal && \
update_livecd_desktop && \
echo "SUCCESS" || \
echo "ERROR"
