# Variables
export DOTFILES=$(dirname $(realpath ${0}))
CURRENT_TIME=$(date -Is)

VIMRC_FILE=${DOTFILES}/vimrc
VIM_SOURCE_FILE=${DOTFILES}/vim_small.sh
VIM_SOURCE_BACKUP_FILE=${DOTFILES}/vim_small.sh.bkp.${CURRENT_TIME}
LOCAL_FILE=${HOME}/.zshrc
LOCAL_BACKUP_FILE=${LOCAL_FILE}.bkp.${CURRENT_TIME}

cd ${DOTFILES}

git submodule init
git submodule update
git submodule update

vim -u ${VIMRC_FILE} +PluginInstall +qall

mv ${VIM_SOURCE_FILE} ${VIM_SOURCE_BACKUP_FILE}
for file in /usr/bin/vim*
do
    name=$(basename ${file})
    echo "alias ${name}=\"${file} -u ${VIMRC_FILE}\"" >> ${VIM_SOURCE_FILE}
done

mv ${LOCAL_FILE} ${LOCAL_BACKUP_FILE}

cat << EOF >> ${LOCAL_FILE}
export DOTFILES="${DOTFILES}"
source ${VIM_SOURCE_FILE}
source ${DOTFILES}/zshrc_small
EOF

