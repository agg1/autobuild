#!/bin/sh

mkdir -p /home/catalyst/extra_overlay/{metadata,profiles}
echo 'extra' > /home/catalyst/extra_overlay/profiles/repo_name
echo 'masters = gentoo' > /home/catalyst/extra_overlay/metadata/layout.conf
chown -R portage:portage /home/catalyst/extra_overlay

# build package
#ebuild foo.ebuild clean manifest package
# version bump with new ebuild script
#repoman --digest=y -d full
