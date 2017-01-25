V=8.0
v=$(subst .,,${V})

TAR_FILE=vim-${V}.tar.bz2
INSTALL_DIR=${HOME}/dotfiles/vim-install
TEMP_DIR=${INSTALL_DIR}/vim${v}

all:
	echo 'Choose a target manually please'

linux: | preclean build-vim download-linux install clean move-zshrc

mac: | preclean build-vim download-mac install clean move-zshrc

preclean:
	if [ -d "${INSTALL_DIR}" ]; then rm -r ${INSTALL_DIR}; fi

build-vim:
	echo 'Create install directory'
	mkdir -p ${INSTALL_DIR}

download-linux:
	echo 'Download vim'
	wget ftp://ftp.vim.org/pub/vim/unix/${TAR_FILE} ${INSTALL_DIR}/${TAR_FILE}

download-mac:
	echo 'Download vim'
	curl ftp://ftp.vim.org/pub/vim/unix/${TAR_FILE} -o ${INSTALL_DIR}/${TAR_FILE}

install:
	echo 'Untar files'
	cd vim-install; tar xvzf ${TAR_FILE}
	echo 'Configure vim'
	cd ${TEMP_DIR}; \
		./configure --prefix=${TEMP_DIR}-install --with-features=huge --enable-pythoninterp --enable-rubyinterp --with-python-config-dir=/usr/lib/python2.6/config --enable-cscope --enable-luainterp; \
		make; \
		make install
	echo alias vim='"${TEMP_DIR}-install/bin/vim -u ${HOME}/dotfiles/vimrc"' >> ${INSTALL_DIR}/vim.zsh

clean:
	rm ${INSTALL_DIR}/${TAR_FILE}
	rm -r ${TEMP_DIR}

move-zshrc:
	if [ -f ${HOME}/.zshrc ]; then \
		mv ${HOME}/.zshrc ${HOME}/.zshrc_before_dotfile_change; \
	fi
	cp ${HOME}/dotfiles/zshrc ${HOME}/.zshrc

undo-zshrc:
	if [ -f "${HOME}/.zshrc_before_dotfile_change" ]; then \
		mv ${HOME}/.zshrc_before_dotfile_change ${HOME}/.zshrc; \
	fi
