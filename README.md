echo "# catalyst" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/agg1/catalyst.git
git push -u origin master

git remote add github https://github.com/agg1/catalyst.git
git push -u github master

git remote add padwalker ssh://www01/home/testing/catalyst.git
git push -u padwalker master
