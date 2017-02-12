#!/bin/sh
git remote add origin /media/backup/git/autobuild.git
git push -u origin master

git remote add github https://github.com/agg1/autobuild.git
git push github master

git remote add www02 ssh://www02/home/testing/autobuild.git
git push www02 master
