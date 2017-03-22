#!/bin/zsh

# Check for updates
echo '-Check for dotfile updates-'
cd ${DOTFILES}

git update-index --assume-unchanged .update_counter

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
# Delete temp file and reset update counter
rm update.logfile > /dev/null 2>&1
echo 1 > ${DOTFILES}/.update_counter
cd ${CURRENT_DIRECTORY}
