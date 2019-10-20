#!/bin/sh

source /etc/portage/finalize.sh

echo								>>/etc/portage/make.conf
echo "USE=\"${SPEC_USE_desktop}\""	>>/etc/portage/make.conf

true
