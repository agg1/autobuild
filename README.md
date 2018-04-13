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
2) rm -f /tmp/.relda ; ./autobuild-all.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
- adapt MAKEFLAGS -jN --load-average N and genkernel.conf for parallel jobs according to nCPU present
- adapt SWITCH_CTARGET according to target compiler
- sleep.sh suspend to ram may be broken
- with a new toolchain (gcc, binutils, glibc) new seed stage build is recommended
3) rm -f /tmp/.relda ; ./autobuild-all_vm.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
4) rm -f /tmp/.relda ; ./autobuild-update.sh LATEST-RELDA 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
