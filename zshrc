# ---- Oh My ZShell ---- #
export DOTFILES=${HOME}/dotfiles
export ZSH=${DOTFILES}/oh-my-zsh
CURRENT_DIRECTORY=${PWD}

# Check for updates
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

if [ -f "${HOME}/.zshrc_local" ]; then
	source ${HOME}/.zshrc_local
fi

