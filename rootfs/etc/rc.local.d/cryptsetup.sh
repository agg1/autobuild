#!/bin/sh

if [ -e "/dev/disk/by-id/md-uuid-6aef3b48:44a41291:1a0f817e:c5fed5f1" ]; then
	echo "/dev/disk/by-id/md-uuid-6aef3b48:44a41291:1a0f817e:c5fed5f1"
	cryptsetup open "/dev/disk/by-id/md-uuid-6aef3b48:44a41291:1a0f817e:c5fed5f1" home --type plain --cipher aes-xts-plain --key-size 512 --hash sha512
fi

if [ -e "/dev/disk/by-id/scsi-3600508e000000000d29b2a53dca8050c" ]; then
	echo "/dev/disk/by-id/scsi-3600508e000000000d29b2a53dca8050c"
	cryptsetup open "/dev/disk/by-id/scsi-3600508e000000000d29b2a53dca8050c" backup --type plain --cipher aes-xts-plain64 --key-size 512 --hash sha512
fi

exit 0
