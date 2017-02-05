#!/bin/sh
git remote add github https://github.com/agg1/catalyst.git
git push github master
git remote add origin ssh://www02/home/testing/catalyst.git
git push -u origin master

