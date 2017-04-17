# Needed variables after reset
DEFAULT_ENV=${ZSHRC_DEFAULT_ENV}
DEFAULT_ALIAS=${ZSHRC_DEFAULT_ALIAS}

# Reset env
for entry in `env | sed 's/=.*//'`
do
    unset ${entry}
done

# Reset aliases
unalias -a

# Load default env and alias
source ${DEFAULT_ENV}
source ${DEFAULT_ALIAS}
