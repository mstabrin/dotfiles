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
MINICONDA_ENV=${HOME}/dotfiles/miniconda-envs
ZSHRC_OPTIONS=${HOME}/dotfiles/zshrc-settings

all:
	echo 'Choose a target manually please'

linux:
	${MAKE} run OS=linux

mac:
	${MAKE} run OS=mac

run:
	${MAKE} preclean OS=${OS}
	${MAKE} download-miniconda-${OS} OS=${OS}
	${MAKE} install-miniconda OS=${OS}
	${MAKE} clean-miniconda OS=${OS}
	${MAKE} build-directorys OS=${OS}
	${MAKE} download-vim-${OS} OS=${OS}
	${MAKE} install-vim OS=${OS}
	${MAKE} clean-vim OS=${OS}
	${MAKE} write-vim-zsh OS=${OS}
	${MAKE} install-vim-plugins OS=${OS}
	${MAKE} move-zshrc OS=${OS}
	@echo 'All done'

preclean:
	if [ -d "${VIM_INSTALL_DIR}" ]; then rm -r ${VIM_INSTALL_DIR}; fi
	if [ -d "${MINICONDA_INSTALL_DIR}" ]; then rm -r ${MINICONDA_INSTALL_DIR}; fi

build-directorys:
	echo 'Create vim install directory'
	mkdir -p ${VIM_INSTALL_DIR}
	mkdir -p ${VIM_TEMP_DIR}

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
	cd ${VIM_TEMP_DIR}; \
		export OLD_PATH=${PATH}; \
		export PATH=${MINICONDA_INSTALL_DIR}/envs/python2.7/bin:${PATH}; \
		./configure --prefix=${VIM_TEMP_DIR_2}-install --with-features=huge --enable-rubyinterp --enable-pythoninterp --with-python-config-dir=${MINICONDA_INSTALL_DIR}/envs/python2/lib/python2.7/config --enable-cscope --enable-luainterp; \
		make; \
		make install; \
		export PATH=${OLD_PATH}

write-vim-zsh:
	echo alias oldvim=vim >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vim='"${VIM_TEMP_DIR}-install/bin/vim -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vimdiff='"${VIM_TEMP_DIR}-install/bin/vimdiff -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias rvim='"${VIM_TEMP_DIR}-install/bin/rvim -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vimtutor='"${VIM_TEMP_DIR}-install/bin/vimtutor -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias view='"${VIM_TEMP_DIR}-install/bin/view -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias rview='"${VIM_TEMP_DIR}-install/bin/rview -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vim2='"${VIM_TEMP_DIR_2}-install/bin/vim -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vimdiff2='"${VIM_TEMP_DIR_2}-install/bin/vimdiff -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias rvim2='"${VIM_TEMP_DIR_2}-install/bin/rvim -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias vimtutor2='"${VIM_TEMP_DIR_2}-install/bin/vimtutor -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias view2='"${VIM_TEMP_DIR_2}-install/bin/view -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh
	echo alias rview2='"${VIM_TEMP_DIR_2}-install/bin/rview -u ${HOME}/dotfiles/vimrc"' >> ${VIM_INSTALL_DIR}/vim.zsh

install-vim-plugins:
	${VIM_TEMP_DIR}-install/bin/vim -u ${HOME}/dotfiles/vimrc +PluginInstall +qall
	${VIM_TEMP_DIR_2}-install/bin/vim -u ${HOME}/dotfiles/vimrc +PluginInstall +qall
	./build_vim_plugins.zsh

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
