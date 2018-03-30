#cd /home/autobuild ; git clean -df .
#git crypt unlock key.gcr; cd -
#cd /home/extra_overlay ; git clean -df .
#git crypt unlock key.gcr; cd -

0) create or update gpg signing key
	- autobuild-gentkey.sh
1) autobuild-sync.sh to fetch latest portage tree and gentoo repositories
	- /home/autobuild
	- /media/distfiles
	- /home/packages/desktop
2) setup git repositories
	- /home/seeds
	- /home/autolog
3) autobuild-all.sh
4) autobuild-all_vm.sh
