# ---- Oh My ZShell ---- #
export DOTFILES=${HOME}/dotfiles
export ZSH=${DOTFILES}/oh-my-zsh

# Layout oh my zsh paths
ZSH_THEME="my_afowler"
ZSH_CUSTOM=${DOTFILES}/oh-my-zsh-custom

plugins=(
git
sudo
osx
zsh-syntax-highlighting
)

# Oh my zsh settings
echo "source $ZSH/oh-my-zsh.sh"
source $ZSH/oh-my-zsh.sh

# Load vim alias
if [ -d "${DOTFILES}/vim-install" ]; then
	for file in ${DOTFILES}/vim-install/*.zsh
	do
		echo "source ${file}"
		source $file
	done
fi

# Load zsh related settings
if [ -d "${DOTFILES}/zshrc-settings" ]; then
	for file in ${DOTFILES}/zshrc-settings/*.zsh
	do
		echo "source ${file}"
		source $file
	done
fi

if [ -f "${HOME}/.zshrc_local" ]; then
	source ${HOME}/.zshrc_local
fi
