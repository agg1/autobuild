git filter-branch -f --index-filter 'git rm -r --cached --ignore-unmatch cfg'
git update-ref -d refs/original/refs/heads/master
git filter-branch -f --index-filter 'git rm -r --cached --ignore-unmatch cscripts'
git update-ref -d refs/original/refs/heads/master

