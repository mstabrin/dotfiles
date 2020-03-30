#! /bin/bash

# Operating system
OS=${1}
if [[ -n ${OS} ]]; then
    OS=${OS}
elif [[ ${OSTYPE} = "linux" ]];then
    OS=Linux
elif [[ ${OSTYPE} = "linux-gnu" ]];then
    OS=Linux
elif [[ ${OSTYPE} = "darwin"* ]];then
    OS=MacOSX
else
    "Operating system ${OSTYPE} currently not supported."
    exit 1
fi
echo "Detected operating system: ${OS}"

# Version variables
VIM_DOWNLOAD_VERSION='8.0'
VIM_UNTAR_VERSION=$(echo ${VIM_DOWNLOAD_VERSION} | sed 's/\.//g')
MINICONDA_VERSION='latest'
NCURSES_DOWNLOAD_VERSION='6.1'

# Download names
VIM_DOWNLOAD_FILE="vim-${VIM_DOWNLOAD_VERSION}.tar.bz2"
VIM_DOWNLOAD_PAGE="ftp://ftp.vim.org/pub/vim/unix/${VIM_DOWNLOAD_FILE}"
MINICONDA_DOWNLOAD_FILE="Miniconda3-${MINICONDA_VERSION}-${OS}-x86_64.sh"
MINICONDA_DOWNLOAD_PAGE="https://repo.continuum.io/miniconda/${MINICONDA_DOWNLOAD_FILE}"
NCURSES_DOWNLOAD_FILE="ncurses-${NCURSES_DOWNLOAD_VERSION}.tar.gz"
NCURSES_DOWNLOAD_PAGE="http://ftp.gnu.org/pub/gnu/ncurses/${NCURSES_DOWNLOAD_FILE}"

# Install dirs
export DOTFILES=${PWD}
VIM_INSTALL_DIR=${DOTFILES}/vim-install
MINICONDA_INSTALL_DIR=${DOTFILES}/miniconda-install
NCURSES_INSTALL_DIR=${DOTFILES}/ncurses
MINICONDA_ENV_DIR=${DOTFILES}/miniconda-envs

VIM_CONFIG_DIR=${VIM_INSTALL_DIR}/vim${VIM_UNTAR_VERSION}
VIM_PYTHON2_DIR=${VIM_INSTALL_DIR}/vim_${VIM_UNTAR_VERSION}_python2
VIM_PYTHON3_DIR=${VIM_INSTALL_DIR}/vim_${VIM_UNTAR_VERSION}_python3
NCURSES_CONFIG_DIR=${NCURSES_INSTALL_DIR}/ncurses-${NCURSES_DOWNLOAD_VERSION}
NCURSES_PREFIX_DIR=${NCURSES_INSTALL_DIR}/ncurses-${NCURSES_DOWNLOAD_VERSION}_install

# Ncurses
NCURSES_LIB=${NCURSES_PREFIX_DIR}/lib

# Vim configure dependancys and flags
MINICONDA_PYTHON2=${MINICONDA_INSTALL_DIR}/envs/python2
MINICONDA_PYTHON2_BIN=${MINICONDA_PYTHON2}/bin
MINICONDA_PYTHON2_CONFIG=${MINICONDA_PYTHON2}/lib/python2.7/config
MINICONDA_PYTHON3=${MINICONDA_INSTALL_DIR}/envs/python3.5
MINICONDA_PYTHON3_BIN=${MINICONDA_PYTHON3}/bin
MINICONDA_PYTHON3_CONFIG=${MINICONDA_PYTHON3}/lib/python3.5/config-3.5m
VIM_CONFIGURE_FLAGS="--with-features=huge --enable-rubyinterp --enable-cscope --enable-luainterp --with-tlib=ncurses"
VIM_CONFIGURE_PYTHON2="--enable-pythoninterp --with-python-config-dir=${MINICONDA_PYTHON2_CONFIG}"
VIM_CONFIGURE_PYTHON3="--enable-python3interp --with-python-config-dir=${MINICONDA_PYTHON3_CONFIG}"

# Vim env source file
VIM_SOURCE_FILE=${VIM_INSTALL_DIR}/vim.zsh
VIMRC_FILE=${DOTFILES}/vimrc

# Source env file
current_time=$(date +%Y%m%d_%Hh_%Mm_%Ss)
LOCAL_FILE=${HOME}/.zshrc
BACKUP_FILE=${LOCAL_FILE}.bkp.${current_time}

# Install log
INSTALL_LOG=${DOTFILES}/install.log
MAX_TASKS=16
CURRENT_TASK=1

#-----------------------------------------
#--------------START INSTALLATION---------
#-----------------------------------------

# Clean installation
echo "${CURRENT_TASK}/${MAX_TASKS} Do precleaning"
if [[ -d ${VIM_INSTALL_DIR} ]];then
    echo "    Delete previous vim installation"
    rm -r ${VIM_INSTALL_DIR}
fi
if [[ -d ${MINICONDA_INSTALL_DIR} ]];then
    echo "    Delete previous miniconda installation"
    rm -r ${MINICONDA_INSTALL_DIR}
fi
if [[ -d ${NCURSES_INSTALL_DIR} ]];then
    echo "    Delete previous ncurses installation"
    rm -r ${NCURSES_INSTALL_DIR}
fi
CURRENT_TASK=$((CURRENT_TASK + 1))

#-----------------------------------------
#--------------INSTALL MINICONDA----------
#-----------------------------------------

# Download and install miniconda
echo "${CURRENT_TASK}/${MAX_TASKS} Download miniconda version ${MINICONDA_DOWNLOAD_FILE}"
CURRENT_TASK=$((CURRENT_TASK + 1))
curl -O ${MINICONDA_DOWNLOAD_PAGE} > ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Install miniconda"
CURRENT_TASK=$((CURRENT_TASK + 1))
bash ${MINICONDA_DOWNLOAD_FILE} -b -p ${MINICONDA_INSTALL_DIR} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Remove downloaded file"
CURRENT_TASK=$((CURRENT_TASK + 1))
rm ${MINICONDA_DOWNLOAD_FILE} >> ${INSTALL_LOG} 2>&1

# Install miniconda environments
echo "${CURRENT_TASK}/${MAX_TASKS} Install python2"
CURRENT_TASK=$((CURRENT_TASK + 1))
${MINICONDA_INSTALL_DIR}/bin/conda env create -f ${MINICONDA_ENV_DIR}/python2.yml >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Install python3"
CURRENT_TASK=$((CURRENT_TASK + 1))
${MINICONDA_INSTALL_DIR}/bin/conda env create -f ${MINICONDA_ENV_DIR}/python3.5.yml >> ${INSTALL_LOG} 2>&1

#-----------------------------------------
#--------------INSTALL NCURSES------------
#-----------------------------------------

echo "${CURRENT_TASK}/${MAX_TASKS} Create ncurses install folder"
CURRENT_TASK=$((CURRENT_TASK + 1))
mkdir -p ${NCURSES_INSTALL_DIR} >> ${INSTALL_LOG} 2>&1
cd ${NCURSES_INSTALL_DIR} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Download ncurses"
CURRENT_TASK=$((CURRENT_TASK + 1))
curl -O ${NCURSES_DOWNLOAD_PAGE} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Untar ncurses"
CURRENT_TASK=$((CURRENT_TASK + 1))
tar -xzf ${NCURSES_DOWNLOAD_FILE} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Remove downloaded file"
CURRENT_TASK=$((CURRENT_TASK + 1))
rm ${NCURSES_DOWNLOAD_FILE} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Install ncurses"
CURRENT_TASK=$((CURRENT_TASK + 1))
cd ${NCURSES_CONFIG_DIR}
./configure --prefix=${NCURSES_PREFIX_DIR} >> ${INSTALL_LOG} 2>&1
make -j4 >> ${INSTALL_LOG} 2>&1
make install >> ${INSTALL_LOG} 2>&1

#-----------------------------------------
#--------------INSTALL VIM----------------
#-----------------------------------------


export LDFLAGS=" -L${NCURSES_LIB}"
# Download and untar vim
echo "${CURRENT_TASK}/${MAX_TASKS} Download vim"
CURRENT_TASK=$((CURRENT_TASK + 1))
curl -O ${VIM_DOWNLOAD_PAGE} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} create vim install folder"
CURRENT_TASK=$((CURRENT_TASK + 1))
mkdir -p ${VIM_INSTALL_DIR} >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Untar vim"
CURRENT_TASK=$((CURRENT_TASK + 1))
tar -xf ${VIM_DOWNLOAD_FILE} -C ${VIM_INSTALL_DIR}/ >> ${INSTALL_LOG} 2>&1
echo "${CURRENT_TASK}/${MAX_TASKS} Remove downloaded file"
CURRENT_TASK=$((CURRENT_TASK + 1))
rm ${VIM_DOWNLOAD_FILE} >> ${INSTALL_LOG} 2>&1

OLD_PATH=${PATH}
# Install vim
for python_version in {2..3};do
    MINICONDA_BIN=MINICONDA_PYTHON${python_version}_BIN
    VIM_PREFIX=VIM_PYTHON${python_version}_DIR
    VIM_CONFIGURE=VIM_CONFIGURE_PYTHON${python_version}
    echo "${CURRENT_TASK}/${MAX_TASKS} Install vim with python ${python_version} support"
    CURRENT_TASK=$((CURRENT_TASK + 1))
    export PATH=${!MINICONDA_BIN}:${PATH} >> ${INSTALL_LOG} 2>&1
    cd ${VIM_CONFIG_DIR} >> ${INSTALL_LOG} 2>&1
    ./configure --prefix=${!VIM_PREFIX} ${VIM_CONFIGURE_FLAGS} ${!VIM_CONFIGURE} >> ${INSTALL_LOG} 2>&1
    make -j4 >> ${INSTALL_LOG} 2>&1
    make install >> ${INSTALL_LOG} 2>&1
    cd ${DOTFILES} >> ${INSTALL_LOG} 2>&1
    export PATH=${OLD_PATH} >> ${INSTALL_LOG} 2>&1
done
export LDFLAGS=''

#-----------------------------------------
#--------------WRITE VIM FILES------------
#-----------------------------------------

echo "${CURRENT_TASK}/${MAX_TASKS} Write ${VIM_SOURCE_FILE}"
CURRENT_TASK=$((CURRENT_TASK + 1))
echo 'PATH='"${VIM_PYTHON3_DIR}/bin"':${PATH}' > ${VIM_SOURCE_FILE}
for file in ${VIM_PYTHON3_DIR}/bin/*;do
    name=$(basename ${file})
    echo "alias ${name}=\"${file} -u ${VIMRC_FILE}\"" >> ${VIM_SOURCE_FILE}
done
for file in ${VIM_PYTHON2_DIR}/bin/*;do
    name=$(basename ${file})
    echo "alias ${name}-2=\"${file} -u ${VIMRC_FILE}\"" >> ${VIM_SOURCE_FILE}
done

#-----------------------------------------
#--------------INSTALL GIT SUBMODULES-----
#-----------------------------------------

echo "${CURRENT_TASK}/${MAX_TASKS} Update git submodules"
CURRENT_TASK=$((CURRENT_TASK + 1))
git submodule init
git submodule update
git submodule update

#-----------------------------------------
#--------------INSTALL VIM PLUGINS--------
#-----------------------------------------

echo "${CURRENT_TASK}/${MAX_TASKS} Install vim plugins"
CURRENT_TASK=$((CURRENT_TASK + 1))
${VIM_PYTHON2_DIR}/bin/vim -u ${VIMRC_FILE} +PluginInstall +qall
${VIM_PYTHON2_DIR}/bin/vim -u ${VIMRC_FILE} +PluginUpdate +qall
${VIM_PYTHON3_DIR}/bin/vim -u ${VIMRC_FILE} +PluginInstall +qall
${VIM_PYTHON3_DIR}/bin/vim -u ${VIMRC_FILE} +PluginUpdate +qall

#-----------------------------------------
#--------------Create source file---------
#-----------------------------------------

echo "${CURRENT_TASK}/${MAX_TASKS} Write ${LOCAL_FILE} (Old file is backuped to ${BACKUP_FILE})"
CURRENT_TASK=$((CURRENT_TASK + 1))
if [[ -f ${LOCAL_FILE} ]];then
    mv ${LOCAL_FILE} ${BACKUP_FILE}
fi
echo 'CURRENT_ENV=${1}' >> ${LOCAL_FILE}
echo 'export DOTFILES='"${DOTFILES}" >> ${LOCAL_FILE}
echo 'source ${DOTFILES}/zshrc ${CURRENT_ENV}' >> ${LOCAL_FILE}


echo "Installation finished! Restart your terminal and type 'zsh'"
