# ~/.zshenv — read by every zsh (scripts too): PATH only, keep it tiny
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"
typeset -U path PATH
path=("$HOME/.local/bin" $path)
export PATH
export EDITOR=nvim VISUAL=nvim
