alias update_zshrc="source ${DOTFILES}/update.zsh"

# Transform bdb
function bdb() {
    bdb_names=(${@})
    output_names=()
    for bdb_name in ${bdb_names[@]}
    do
        echo ${bdb_name} | grep '=' 1>/dev/null 2> /dev/null

        if [[ ${?} = 0 ]]
        then
            option_name=$(echo ${bdb_name} | sed 's/\(.*\)=\(.*\)/\1/g')
            bdb_name=$(echo ${bdb_name} | sed 's/\(.*\)=\(.*\)/\2/g')

            if [[ ${bdb_name: -4} = '.bdb' ]]
            then
                base_name=$(basename ${bdb_name})
                dir_name=$(dirname ${bdb_name})
                length_dirname=${#dir_name}
                length_basename=${#base_name}
                output_names+=("${option_name}=bdb:${dir_name:0:$((${length_dirname}-7))}${base_name:0:$((${length_basename}-4))}")

            else
                output_names+=("${option_name}=${bdb_name}")
            fi

        elif [[ ${bdb_name: -4} = '.bdb' ]]
        then
            base_name=$(basename ${bdb_name})
            dir_name=$(dirname ${bdb_name})
            length_dirname=${#dir_name}
            length_basename=${#base_name}
            output_names+=("bdb:${dir_name:0:$((${length_dirname}-7))}${base_name:0:$((${length_basename}-4))}")

        else
            output_names+=(${bdb_name})
        fi

    done
    echo ${output_names[@]}
}

