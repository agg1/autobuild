# when initializing staging PAM packages need to be unmasked
subarch: amd64
target: stage1
version_stamp: latest
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/stage3-amd64-hardened+nomultilib-20160908.tar.bz2
update_seed: yes
update_seed_command: --update --deep @world
portage_confdir: /home/catalyst/etc/portage/
cflags: -O3 -pipe -march=nehalem -mtune=nehalem
cxxflags: -O3 -pipe -march=nehalem -mtune=nehalem
