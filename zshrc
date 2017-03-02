# ---- Oh My ZShell ---- #
export DOTFILES=${HOME}/dotfiles
export ZSH=${DOTFILES}/oh-my-zsh
CURRENT_DIRECTORY=${PWD}

# Check for updates
echo -Check for dotfile updates-
cd ${DOTFILES}

# Check if the timout command exists
timeout 3 sleep 0.5 > /dev/null
if [[ $? == 0 ]]; then
    timeout 3 wget -qO /dev/null --no-check-certificate 'https://github.com/'
    if [[ $? == 0 ]]; then
        echo 'Do update...'
        git pull
    else
        echo "Update failed! Maybe Github is not available!"
    fi
else
    # Check if the timout command exists
    echo 'timeout command not found... search for gtimeout'
    gtimeout 3 sleep 0.5> /dev/null
    if [[ $? == 0 ]]; then
        gtimeout 3 curl -so /dev/null 'https://github.com/'
        if [[ $? == 0 ]]; then
            echo 'Do update...'
            git pull
        else
            echo "Update failed! Maybe Github is not available!"
        fi
    else
        echo "Update failed! No timeout or gtimeout command found!"
    fi
fi
cd ${CURRENT_DIRECTORY}

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
echo "source $ZSH/oh-my-zsh.sh"
source $ZSH/oh-my-zsh.sh

# Load vim alias
if [ -d "${DOTFILES}/vim-install" ]; then
	for file in ${DOTFILES}/vim-install/*.zsh
	do
		echo "source ${file}"
		source $file
	done
fi

# Load zsh related settings
if [ -d "${DOTFILES}/zshrc-settings" ]; then
	for file in ${DOTFILES}/zshrc-settings/*.zsh
	do
		echo "source ${file}"
		source $file
	done
fi

if [ -f "${HOME}/.zshrc_local" ]; then
	source ${HOME}/.zshrc_local
fi
