# Local variables
CURRENT_DIRECTORY=${PWD}
DEFAULT_SOURCE=${HOME}/.zshrc_local
CURRENT_SOURCE=${1}

# Check if it is an update or a new session
if [[ ! -n ${UPDATE_ZSH_ENV} ]]; then
    # Load for the first time (new session)
    export DOTFILES=${HOME}/dotfiles
    export ZSH=${DOTFILES}/oh-my-zsh
    export ZSHRC_DEFAULT_ENV=${DOTFILES}/zshrc-settings/zshrc_default_env
    export ZSHRC_DEFAULT_ALIAS=${DOTFILES}/zshrc-settings/zshrc_default_alias
    export UPDATE_ZSH_ENV=true
    export UPDATE_ZSH_FILE=${DOTFILES}/update.zsh
    export UPDATE_ZSH_COUNT_FILE=${DOTFILES}/.update_counter

    # Write current environment
    source ${DOTFILES}/write_env.zsh
else
    source ${DOTFILES}/reset_env.zsh
fi

# Check for dotfiles github updates
update_count=$(cat ${UPDATE_ZSH_COUNT_FILE})
if [[ $((${update_count} % 20)) == 0 ]]; then
    echo 'You did not check for updates for several logins: Do you want to check for updates? [y/n]: '
    read input
    if [[ $input == 'y' ]]; then
        source ${UPDATE_ZSH_FILE}
    else
        echo 'Skip update'
    fi
fi
echo $((${update_count}+1)) > ${UPDATE_ZSH_COUNT_FILE}

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
if [[ -d "${DOTFILES}/vim-install" ]]; then
	for file in ${DOTFILES}/vim-install/*.zsh
	do
		source $file
	done
fi

# Load zsh related settings
if [[ -d "${DOTFILES}/zshrc-settings" ]]; then
	for file in ${DOTFILES}/zshrc-settings/*.zsh
	do
		source $file
	done
fi

# Source default
if [[ -f "${DEFAULT_SOURCE}" ]]; then
	source ${DEFAULT_SOURCE} ${CURRENT_SOURCE}
fi

cd ${CURRENT_DIRECTORY}
