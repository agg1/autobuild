0) create or update gpg signing key
	- autobuild-genkey.sh
1) create directories and manually prepare catalyst if required with initial build
	- check make.conf settings match portage tree version (python etc), revert when done
		- adapt MAKEFLAGS -jN --load-average N and genkernel.conf for parallel jobs according to nCPU present
		- adapt SWITCH_CTARGET according to target compiler
	- emerge -vb catalyst from appropriate portage tree, mount --bind distfiles, unmount when done
	- emerge shc compiler
	- consider manually mounting TMP to /var/tmp
	- rm -f /tmp/.prepared /tmp/.reldate
- sleep.sh suspend to ram may be broken
2) rm -f /tmp/.reldate ; ./autobuild-all.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
	- builds everything from scratch from an INITSTAGE stage3 tarball to be supplied
	- including a new stage3 tarball
	- including a new kernel stage
	- and all the livecd flavors
	- recommended with toolchain update (gcc, glibc, binutils etc.)
	- a kernel stage build is recommended with kernel updates
3) rm -f /tmp/.reldate ; ./autobuild-all_vm.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
	- build all virtual machin livecd ISOs
4) rm -f /tmp/.reldate ; ./autobuild-update.sh LATEST-RELDA 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
	- updates all livecd flavors without building a fresh seed stage
	- kernel build is updated if new sources are available or kernel config changed with every livecd stage
          if kernel stage was not updated
