# Local variables
CURRENT_SOURCE=${1}
DEFAULT_SOURCE=${HOME}/.zshrc_local
DOTFILES_LOC=${DOTFILES}

# LOGIN specific variables
export ZSH=${DOTFILES}/oh-my-zsh
export DEFAULT_LOGIN_ENV=${HOME}/.default_login_env
export DEFAULT_LOGIN_ALIAS=${HOME}/.default_login_alias
export UPDATE_ZSH_FILE=${DOTFILES}/update.zsh
export UPDATE_ZSH_COUNT_FILE=${DOTFILES}/.update_counter

# Check if it is an update or a new session
if [[ ${UPDATE_LOGIN_ENV} != true ]]; then
    # Write current environment
    export UPDATE_LOGIN_ENV=true
    source ${DOTFILES}/write_env.zsh
else
    echo "Reset environment"
    source ${DOTFILES}/reset_env.zsh
    # LOGIN specific variables
    export DOTFILES=${DOTFILES_LOC}
    export ZSH=${DOTFILES}/oh-my-zsh
    export DEFAULT_LOGIN_ENV=${HOME}/.default_login_env
    export DEFAULT_LOGIN_ALIAS=${HOME}/.default_login_alias
    export UPDATE_LOGIN_ENV=true
    export UPDATE_ZSH_FILE=${DOTFILES}/update.zsh
    export UPDATE_ZSH_COUNT_FILE=${DOTFILES}/.update_counter
fi

# Check for dotfiles github updates
if [[ -f ${UPDATE_ZSH_COUNT_FILE} ]]; then
	update_count=$(cat ${UPDATE_ZSH_COUNT_FILE})
fi
if [[ -z ${update_count} ]]
then
    update_count=1
fi

# Layout oh my zsh paths
ZSH_THEME="my_afowler"
ZSH_CUSTOM=${DOTFILES}/oh-my-zsh-custom

# Disable syntax highlighting on clr subnodes
if [[ ${HOSTNAME} =~ 'dn[0-9][0-9]' ]]; then
    plugins=(
    git
    sudo
    macos
    )
else
    plugins=(
    git
    sudo
    macos
    zsh-syntax-highlighting
    )
fi

ZSH_DISABLE_COMPFIX=true

# Oh my zsh settings
source $ZSH/oh-my-zsh.sh 2>/dev/null

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
		source $file 2>/dev/null
	done
fi

DID_NO_UPDATE=true
#if [[ $((${update_count} % 20)) == 0 ]]; then
#    echo $((${update_count}+1)) > ${UPDATE_ZSH_COUNT_FILE}
#    echo 'You did not check for updates for several logins: Do you want to check for updates? [y/n]: '
#    read input
#    if [[ $input == 'y' ]]; then
#        source ${UPDATE_ZSH_FILE}
#        source ${0} ${CURRENT_SOURCE}
#        DID_NO_UPDATE=false
#    else
#        echo 'Skip update'
#    fi
#else
#    echo $((${update_count}+1)) > ${UPDATE_ZSH_COUNT_FILE}
#fi

# Source default
if [[ ${DID_NO_UPDATE} = true ]];then
    if [[ -f "${DEFAULT_SOURCE}" ]]; then
        source ${DEFAULT_SOURCE} ${CURRENT_SOURCE}
    fi
fi

# Load the ssh agent
GOT_AGENT=0

for FILE in $(find /tmp/ssh-* -type s -user ${LOGNAME} -name "agent.[0-9]*" 2>/dev/null)
do
    SOCK_PID=${FILE##*.}

    PID=$(ps -fu${LOGNAME}|awk '/ssh-agent/ && ( $2=='${SOCK_PID}' || $3=='${SOCK_PID}' || $2=='${SOCK_PID}' +1 ) {print $2}')

    SOCK_FILE=${FILE}

    SSH_AUTH_SOCK=${SOCK_FILE}; export SSH_AUTH_SOCK;
    SSH_AGENT_PID=${PID}; export SSH_AGENT_PID;

    keys=$(ssh-add -L 2>/dev/null)
    if [[ $? != 2 && -n ${PID} ]]
    then
        GOT_AGENT=1
        echo "Agent pid ${PID}"
        for key in $(find ${HOME}/.ssh -name '*id_*' -not -name '*.pub')
        do
            public_key=$(cat ${key}.pub | awk '{ print $2 }')
            if ! echo "${keys}" | grep -q "${public_key}"
            then
                ssh-add ${key}
            fi
        done
        break
    fi
    #echo "Skipping pid ${PID}"

done

current_host=$(hostname -s)
if [[ ${current_host} == m21003-lin || ${current_host} == markud-t460s ]]
then
    if [[ $GOT_AGENT = 0 ]]
    then
        eval `ssh-agent`
        ssh-add
    fi
fi
