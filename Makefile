V=8.0
v=$(subst .,,${V})

VIM_TAR_FILE=vim-${V}.tar.bz2
VIM_INSTALL_DIR=${HOME}/dotfiles/vim-install
VIM_TEMP_DIR=${VIM_INSTALL_DIR}/vim${v}
VIM_TEMP_DIR_2=${VIM_INSTALL_DIR}/vim${v}-2
MINICONDA_SH_FILE_MAC=Miniconda3-latest-MacOSX-x86_64.sh
MINICONDA_SH_FILE_LINUX=Miniconda3-latest-Linux-x86_64.sh
MINICONDA_SH_FILE_OUT=Miniconda.sh
MINICONDA_INSTALL_DIR=${HOME}/dotfiles/miniconda-install
MINICONDA_REL=miniconda-install
MINICONDA_TEMP=${HOME}/dotfiles
MINICONDA_ZSHRC=miniconda.zsh
MINICONDA_ENV=${HOME}/dotfiles/miniconda-envs
ZSHRC_OPTIONS=${HOME}/dotfiles/zshrc-settings

all:
	echo 'Choose a target manually please'

linux: | preclean build-directorys download-miniconda-linux install-miniconda clean-miniconda download-vim-linux install-vim clean-vim move-zshrc

mac: | preclean build-directorys download-miniconda-mac install-miniconda clean-miniconda download-vim-mac install-vim clean-vim move-zshrc

preclean:
	if [ -d "${VIM_INSTALL_DIR}" ]; then rm -r ${VIM_INSTALL_DIR}; fi
	if [ -d "${MINICONDA_INSTALL_DIR}" ]; then rm -r ${MINICONDA_INSTALL_DIR}; fi
	if [ -e "${MINICONDA_TEMP}/${MINICONDA_ZSHRC}" ]; then rm ${MINICONDA_TEMP}/${MINICONDA_ZSHRC}; fi

build-directorys:
	echo 'Create vim install directory'
	mkdir -p ${VIM_INSTALL_DIR}
	mkdir -p ${VIM_TEMP_DIR}
	mkdir -p ${VIM_TEMP_DIR_2}

download-vim-linux:
	echo 'Download vim'
	wget ftp://ftp.vim.org/pub/vim/unix/${VIM_TAR_FILE} -O ${VIM_INSTALL_DIR}/${VIM_TAR_FILE}
	echo 'Untar files'
	cd ${VIM_INSTALL_DIR}; tar xvf ${VIM_TAR_FILE}

download-vim-mac:
	echo 'Download vim'
	curl ftp://ftp.vim.org/pub/vim/unix/${VIM_TAR_FILE} -o ${VIM_INSTALL_DIR}/${VIM_TAR_FILE}
	echo 'Untar files'
	cd ${VIM_INSTALL_DIR}; tar xvzf ${VIM_TAR_FILE}

install-vim:
	echo 'Configure vim'
	cd ${VIM_TEMP_DIR}; \
		export OLD_PATH=${PATH}; \
		export PATH=${MINICONDA_INSTALL_DIR}/envs/python3.5/bin:${PATH}; \
		./configure --prefix=${VIM_TEMP_DIR}-install --with-features=huge --enable-rubyinterp --enable-python3interp --with-python3-config-dir=${MINICONDA_INSTALL_DIR}/envs/python3.5/lib/python3.5/config-3.5m --enable-cscope --enable-luainterp; \
		make; \
		make install; \
		export PATH=${OLD_PATH}
	echo alias oldvim=vim >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vim='"${VIM_TEMP_DIR}-install/bin/vim -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	cd ${VIM_TEMP_DIR}; \
		export PATH=${MINICONDA_INSTALL_DIR}/envs/python2.7/bin:${PATH}; \
		./configure --prefix=${VIM_TEMP_DIR_2}-install --with-features=huge --enable-rubyinterp --enable-pythoninterp --with-python-config-dir=${MINICONDA_INSTALL_DIR}/envs/python2/lib/python2.7/config --enable-cscope --enable-luainterp; \
		make; \
		make install; \
		export PATH=${OLD_PATH}
	echo alias vim2='"${VIM_TEMP_DIR_2}-install/bin/vim -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh

download-miniconda-linux:
	echo 'Download miniconda'
	wget https://repo.continuum.io/miniconda/${MINICONDA_SH_FILE_LINUX} -O ${MINICONDA_TEMP}/${MINICONDA_SH_FILE_OUT}

download-miniconda-mac:
	echo 'Download miniconda'
	curl https://repo.continuum.io/miniconda/${MINICONDA_SH_FILE_MAC} -o ${MINICONDA_TEMP}/${MINICONDA_SH_FILE_OUT}

install-miniconda:
	bash ${MINICONDA_TEMP}/${MINICONDA_SH_FILE_OUT} -b -p ${MINICONDA_INSTALL_DIR}
	${MINICONDA_INSTALL_DIR}/bin/conda env create -f ${MINICONDA_ENV}/python2.yml
	${MINICONDA_INSTALL_DIR}/bin/conda env create -f ${MINICONDA_ENV}/python3.5.yml

clean-miniconda:
	rm ${MINICONDA_TEMP}/${MINICONDA_SH_FILE_OUT}

clean-vim:
	rm ${VIM_INSTALL_DIR}/${VIM_TAR_FILE}
	rm -r ${VIM_TEMP_DIR}
	rm -r ${VIM_TEMP_DIR_2}

move-zshrc:
	if [ -f ${HOME}/.zshrc_before_dotfile_change ]; then \
		mv ${HOME}/.zshrc_before_dotfile_change ${HOME}/.zshrc; \
	fi
	if [ -f ${HOME}/.zshrc ]; then \
		mv ${HOME}/.zshrc ${HOME}/.zshrc_before_dotfile_change; \
	fi
	cp ${HOME}/dotfiles/copy_this.zshrc ${HOME}/.zshrc

undo-zshrc:
	if [ -f "${HOME}/.zshrc_before_dotfile_change" ]; then \
		mv ${HOME}/.zshrc_before_dotfile_change ${HOME}/.zshrc; \
	fi
