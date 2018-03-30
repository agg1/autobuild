#cd /home/autobuild ; git clean -df .
#git crypt unlock key.gcr; cd -
#cd /home/extra_overlay ; git clean -df .
#git crypt unlock key.gcr; cd -

0) create or update gpg signing key
	- autobuild-gentkey.sh
1) setup git repositories
	- /home/seeds
	- /home/autolog
2) autobuild-all.sh
3) autobuild-all_vm.sh
