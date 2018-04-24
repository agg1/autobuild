0) create or update gpg signing key
	- check autobuild.conf
	- autobuild-genkey.sh
1) create directories and manually prepare catalyst if required with initial build
	- check make.conf settings match portage tree version (python etc), revert when done
		- adapt MAKEFLAGS -jN --load-average N and genkernel.conf for parallel jobs according to nCPU present
		- adapt SWITCH_CTARGET according to target compiler
	- adapt paths in autobuild.conf and spec files
	- emerge -vb catalyst shc lzop
2) ./autobuild-all.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
	- builds everything from scratch from an INITSTAGE stage3 tarball to be supplied
	- including fresh seed stages and fresh kernel stage
	- and all the livecd flavors
	- recommended with toolchain updates (gcc, glibc, binutils etc.)
	- a kernel stage build is recommended with kernel updates
3) ./autobuild-all_vm.sh 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
	- build all virtual machine livecd ISOs
4) ./autobuild-update.sh LATEST-RELDA 2>&1 | tee -a /home/autolog/build.log ; /usr/local/bin/sleep.sh
	- updates all livecd flavors without building a fresh seed stage
	- kernel build is updated with every flavor individually if new sources are available or kernel config changed
