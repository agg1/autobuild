git crypt status -f
git filter-branch -f --index-filter "git rm -r --cached --ignore-unmatch $CRYPT_TARGET"
git update-ref -d refs/original/refs/heads/master
