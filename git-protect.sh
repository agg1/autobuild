#!/bin/sh
git crypt keygen /home/user/catalyst.gcr
git crypt init /home/user/catalyst.gcr
git crypt unlock /home/user/catalyst.gcr
git-crypt status -f
git crypt lock

