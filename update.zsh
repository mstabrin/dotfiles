#!/bin/zsh

# Check for updates
echo '-Check for dotfile updates-'
if [[ -n ${CURRENT_DIRECTORY} ]]; then
    CURRENT_DIRECTORY=${PWD}
fi
UPDATE_LOG_FILE=${DOTFILES}/update.logfile
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
    git fetch --dry-run 1>${UPDATE_LOG_FILE} 2>&1
    # Check if you need to update
    do_stat=false
    do_gstat=false

    stat -c%s ${UPDATE_LOG_FILE} > /dev/null 2>&1
    if [[ $? == 0 ]]; then
        do_stat=true
        do_gstat=false
    fi

    gstat -c%s ${UPDATE_LOG_FILE} > /dev/null 2>&1
    if [[ $? == 0 ]]; then
        do_stat=false
        do_gstat=true
    fi

    if [[ $do_stat = true ]]; then
        size=$(stat -c%s ${UPDATE_LOG_FILE})
    elif [[ $do_gstat = true ]]; then
        size=$(gstat -c%s ${UPDATE_LOG_FILE})
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
rm ${UPDATE_LOG_FILE} > /dev/null 2>&1
echo 1 > ${UPDATE_ZSH_COUNT_FILE}
cd ${CURRENT_DIRECTORY}

