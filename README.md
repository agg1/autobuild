0) create or update gpg signing key
	- check autobuild.conf
	- check autobuild-genkey.sh
1) create directories and manually prepare catalyst if required with initial build
	- check autobuild.conf
	- adapt MAKEFLAGS -jN --load-average N and genkernel.conf for parallel jobs according to nCPU present
	  +50% with N=6 for 4 cores or N=16 for 12 cores
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
