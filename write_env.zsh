# Write files
printenv | grep -v _= | grep -v module= | grep -v '}' | sed 's/^\([A-Za-z0-9_]*=\)\(.*\)$/export \1"\2"/g' > ${DEFAULT_LOGIN_ENV}
alias | sed 's/\(^.*\)/alias \1/g' > ${DEFAULT_LOGIN_ALIAS}
