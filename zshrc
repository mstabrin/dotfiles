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
source $ZSH'/oh-my-zsh.sh'
