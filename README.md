#cd /home/autobuild ; git clean -df .
#git crypt unlock key.gcr; cd -
#cd /home/extra_overlay ; git clean -df .
#git crypt unlock key.gcr; cd -

0) create or update gpg signing key
	- autobuild-gentkey.sh
1) create directories and manually prepare catalyst if required with initial build
	- /home/seeds
	- /home/autolog
	- check make.conf settings match portage tree version (python etc), revert when done
	- emerge -vb catalyst from appropriate portage tree, mount --bind distfiles, unmount when done
	- emerge shc compiler
	- consider manually mounting TMP to /var/tmp
	- rm /home/portage/.prepared ; rm /tmp/.relda
2) rm /tmp/.relda ; ./autobuild-all.sh 2>&1 | tee -a /home/autolog/autobuild.log
3) rm /tmp/.relda ; ./autobuild-all_vm.sh 2>&1 | tee -a /home/autolog/autobuild.log
4) rm /tmp/.relda ; ./autobuild-update.sh 2>&1 | tee -a /home/autolog/autobuild.log
