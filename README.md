0) create or update gpg signing key
	- check autobuild.conf
	- autobuild-genkey.sh
1) create directories and manually prepare catalyst if required with initial build
	- adapt MAKEFLAGS -jN --load-average N and genkernel.conf for parallel jobs according to nCPU present
	  +50% with N=6 for 4 cores or N=16 for 12 cores
	- adapt SWITCH_CTARGET according to target compiler
	- adapt paths in autobuild.conf and spec files
	- emerge -vb catalyst shc lzop
2) ./autobuild-all.sh
	- builds everything from scratch from an INITSTAGE stage3 tarball to be supplied
	- including fresh seed stages and fresh kernel stage
	- and all the livecd flavors
	- recommended with toolchain updates (gcc, glibc, binutils etc.)
	- a kernel stage build is recommended with kernel updates
3) ./autobuild-all_vm.sh
	- build all virtual machine livecd ISOs
4) ./autobuild-update.sh <LATEST-RELDA>
	- updates all livecd flavors without building a fresh seed stage
	- kernel build is updated with every flavor individually if new sources are available or kernel config changed
