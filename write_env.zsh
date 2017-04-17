# Write files
env | sed 's/\(^.*\)/export \1/g' > ${ZSHRC_DEFAULT_ENV}
alias | sed 's/\(^.*\)/alias \1/g' > ${ZSHRC_DEFAULT_ALIAS}
