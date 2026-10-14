# ~/.zshrc — fast interactive zsh, no framework (starts in a few ms)

# ── history ──────────────────────────────────────────────
HISTFILE=~/.histfile HISTSIZE=50000 SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
setopt autocd extendedglob interactive_comments no_beep

# ── completion (dump rebuilt at most once a day) ─────────
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'          # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── keys (emacs style + sensible extras) ─────────────────
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search; zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search    # ↑ / ↓ search history by what you typed
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;5C' forward-word                # Ctrl+→ / Ctrl+←
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line  '^[[F' end-of-line  '^[[3~' delete-char  '^H' backward-kill-word

# ── prompt: dir (git-branch) ❯   red ❯ after a failed command, # when root ──
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{215}%b%f'
precmd() { vcs_info }
setopt prompt_subst
PROMPT='%F{223}%~%f${vcs_info_msg_0_} %(?.%F{209}.%F{203})%(!.#.❯)%f '

# ── aliases ──────────────────────────────────────────────
alias ls='ls --color=auto --group-directories-first' ll='ls -lah' la='ls -A'
alias grep='grep --color=auto' diff='diff --color=auto' ip='ip -color=auto'
alias cat='bat --paging=never --style=plain'
alias update='yay -Syu'                        # system + AUR, run as yourself (not sudo)
alias cleanup='yay -Yc && sudo paccache -rk2'  # remove orphans + old package cache
alias please='sudo $(fc -ln -1)'               # rerun last command with sudo

# ── plugins (from pacman; syntax-highlighting must be last) ──
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7d6a66'
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
