0) create or update gpg signing key
	- autobuild-gentkey.sh
1) create directories and manually prepare catalyst if required with initial build
	- /home/seeds
	- /home/autolog
	- check make.conf settings match portage tree version (python etc), revert when done
	- emerge -vb catalyst from appropriate portage tree, mount --bind distfiles, unmount when done
	- emerge shc compiler
	- consider manually mounting TMP to /var/tmp
	- rm -f /tmp/.prepared /tmp/.relda
2) rm -f /tmp/.relda /tmp/.prepared ; ./autobuild-all.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
- adapt MAKEFLAGS -jN --load-average N and genkernel.conf for parallel jobs according to nCPU present
- adapt SWITCH_CTARGET according to target compiler
- sleep.sh suspend to ram may be broken
3) rm -f /tmp/.relda /tmp/.prepared ; ./autobuild-all_vm.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
4) rm -f /tmp/.relda /tmp/.prepared ; ./autobuild-update.sh LATEST-RELDA 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
- update build may break with a kernel update involved
  in that case a build against an old init-stage3 with autobuild-all.sh instead may help
  just place a symlink for RELDA on init stage
- there is three variants to build a release
	a) autobuild-all.sh
	b) autobuild-all.sh beginning against previous init stage3 from a)
	c) autobuild-update.sh against previous stage1 of the individual flavor
	- this is known to break with kernel update involved (kernel headers)
	  iptables and ip link not autoloading kernel modules any longer
	- a flawless minimal flavor stage is required for all virtual machine flavors
	- admin, desktop and full flavor must be considered likewise wether init stage3
	  or previous flavor stage1 can be utilized
