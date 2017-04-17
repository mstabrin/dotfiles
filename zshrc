# Local variables
CURRENT_DIRECTORY=${PWD}
DEFAULT_SOURCE=${HOME}/.zshrc_local
CURRENT_SOURCE=${1}

# Check if it is an update or a new session
if [[ ! -n ${UPDATE_ENV} ]]; then
    # Load for the first time (new session)
    export DOTFILES=${HOME}/dotfiles
    export ZSH=${DOTFILES}/oh-my-zsh
    export ZSHRC_DEFAULT_ENV=${DOTFILES}/zshrc-settings/zshrc_default_env
    export ZSHRC_DEFAULT_ALIAS=${DOTFILES}/zshrc-settings/zshrc_default_alias
    export UPDATE_ENV=true

    # Write current environment
    source ${DOTFILES}/write_env.zsh
    FILE_TO_SOURCE=${CURRENT_SOURCE}
else
    # Change environment
    source ${DOTFILES}/reset_env.zsh
    FILE_TO_SOURCE=${DEFAULT_SOURCE}
fi

# Check for dotfiles github updates
update_count=$(cat ${DOTFILES}/.update_counter)
if [[ $(($update_count % 20)) == 0 ]]; then
    echo 'You did not check for updates for several logins: Do you want to check for updates? [y/n]: '
    read input
    if [[ $input == 'y' ]]; then
        source ${DOTFILES}/update.zsh
    else
        echo 'Skip update'
    fi
fi
echo $(($update_count+1)) > ${DOTFILES}/.update_counter

# Layout oh my zsh paths
ZSH_THEME="my_afowler"
ZSH_CUSTOM=${DOTFILES}/oh-my-zsh-custom

# Disable syntax highlighting on clr subnodes
if [[ ${HOSTNAME} =~ 'dn[0-9][0-9]' ]]; then
    plugins=(
    git
    sudo
    osx
    )
else
    plugins=(
    git
    sudo
    osx
    zsh-syntax-highlighting
    )
fi

# Oh my zsh settings
source $ZSH/oh-my-zsh.sh

# Load vim alias
if [ -d "${DOTFILES}/vim-install" ]; then
	for file in ${DOTFILES}/vim-install/*.zsh
	do
		source $file
	done
fi

# Load zsh related settings
if [ -d "${DOTFILES}/zshrc-settings" ]; then
	for file in ${DOTFILES}/zshrc-settings/*.zsh
	do
		source $file
	done
fi

if [ -f "${FILE_TO_SOURCE}" ]; then
	source ${FILE_TO_SOURCE}
fi

