# dotfiles

## Cloning

```bash
git clone -r https://github.com/mstabrin/dotfiles
cd dotfiles
```

or if -r is not provided:

```bash
git clone https://github.com/mstabrin/dotfiles
cd dotfiles
git submodule init
git submodule update
```

## Installation

Assuming one is inside the dotfiles directory
```bash
bash ./install.sh
```

## Install vimrc

Assuming one is inside the dotfiles directory
```bash
echo "export DOTFILES=$(realpath .)" >> ${HOME}/.bashrc
echo "alias vim='vim -u "'${DOTFILES}'"/vimrc'" >> ${HOME}/.bashrc
source ${HOME}/.bashrc
vim +PluginInstall +qall
```
