# Build YouCompleteMe

YOUCOMPLETEME_PATH=${DOTFILES}/vim-plugin/YouCompleteMe
if [[ -d "${YOUCOMPLETEME_PATH}" ]]; then
    temp_dir=${PWD}
    cd ${YOUCOMPLETEME_PATH}
    ./install.py --all
    cd ${temp_dir}
fi
