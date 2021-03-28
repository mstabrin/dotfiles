# dotfiles

## Cloning

> git clone -r https://github.com/mstabrin/dotfiles
> cd dotfiles

or if -r is not provided:

> git clone https://github.com/mstabrin/dotfiles
> cd dotfiles
> git submodule init
> git submodule update

## Installation

> bash ./install.sh

## Install vimrc

> echo "export DOTFILES=$(realpath .)" >> ${HOME}/.bashrc
> echo "alias vim='vim -u "'${DOTFILES}'"/vimrc'" >> ${HOME}/.bashrc
> source ${HOME}/.bashrc
> vim +PluginInstall +qall
