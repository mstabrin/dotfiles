# Write files
printenv | grep -v _=| grep -v module= | grep -v '}' | sed 's/^\([A-Za-z0-9_]*=\)\(.*\)$/export \1"\2"/g' > ${ZSHRC_DEFAULT_ENV}
alias | sed 's/\(^.*\)/alias \1/g' > ${ZSHRC_DEFAULT_ALIAS}
