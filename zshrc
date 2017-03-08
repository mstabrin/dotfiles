# ---- Oh My ZShell ---- #
export DOTFILES=${HOME}/dotfiles
export ZSH=${DOTFILES}/oh-my-zsh
CURRENT_DIRECTORY=${PWD}


# Check for updates
echo '-Check for dotfile updates-'
cd ${DOTFILES}

# Check if the timout command exists
timeout 1 sleep 0.1 > /dev/null 2>&1
do_update=$?
if [[ ${do_update} == 0 ]]; then
    # Use timeout
    timeout 3 wget -qO /dev/null --no-check-certificate 'https://github.com/'
    do_update=$?
else
    # Check if the gtimout command exists
    gtimeout 1 sleep 0.1 > /dev/null 2>&1
    do_update=$?
    if [[ ${do_update} == 0 ]]; then
        # Use timeout
        gtimeout 3 curl -so /dev/null 'https://github.com/'
        do_update=$?
    else
        echo 'Update failed! No timeout or gtimeout command found!'
    fi
fi

# If successful check for updates, else dont
if [[ ${do_update} == 0 ]]; then
    git fetch --dry-run > update.logfile 2>&1
    # Check if you need to update
    do_stat=false
    do_gstat=false

    stat -c%s update.logfile > /dev/null 2>&1
    if [[ $? == 0 ]]; then
        do_stat=true
    fi

    gstat -c%s update.logfile > /dev/null 2>&1
    if [[ $? == 0 ]]; then
        do_gstat=true
    fi

    if [[ do_stat = true ]]; then
        size=$(stat -c%s update.logfile)
    elif [[ do_gstat = true ]]; then
        size=$(gstat -c%s update.logfile)
    else
        size=0
    fi

    if [[ ${size} > 4 ]]; then
        echo 'Update available! Do you want to update? [y/n]'
        read input
        if [[ $input == 'y' ]]; then
            git pull
            git submodule update
            vim +PluginInstall +qall
        else
            echo 'Skip update'
        fi
    else
        echo 'No update available'
    fi
else
    echo 'Update failed!'
fi
rm update.logfile > /dev/null 2>&1
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

