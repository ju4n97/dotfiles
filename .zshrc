# ────────────────────────────────────────────────────────────────
# Fast Prompt (initial render happens immediately)
# ────────────────────────────────────────────────────────────────
eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.json")"

# ────────────────────────────────────────────────────────────────
# Zinit bootstrap
# ────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && mkdir -p "${ZINIT_HOME%/*}"
[[ ! -d "$ZINIT_HOME/.git" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

autoload -Uz compinit
compinit -C

# ────────────────────────────────────────────────────────────────
# Plugin loading
# ────────────────────────────────────────────────────────────────
# light plugins
zinit light zsh-users/zsh-completions
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# heavy plugins
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Restore working directory replay
zinit cdreplay -q

# ────────────────────────────────────────────────────────────────
# Keybindings (vi mode)
# ────────────────────────────────────────────────────────────────
bindkey -v
bindkey -M viins jk vi-cmd-mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

vi-yank-clipboard() {
  zle vi-yank
  printf "%s" "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# ────────────────────────────────────────────────────────────────
# History
# ────────────────────────────────────────────────────────────────
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

setopt appendhistory sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ────────────────────────────────────────────────────────────────
# Aliases
# ────────────────────────────────────────────────────────────────
alias ls='ls --color'
alias la='ls --color -la'
alias task='go-task'
alias dumpfiles="$HOME/.local/bin/dumpfiles.sh"

expand-alias() { zle _expand_alias; }
zle -N expand-alias
bindkey '^@' expand-alias

# ────────────────────────────────────────────────────────────────
# PATH
# ────────────────────────────────────────────────────────────────
path+=("$HOME/.local/bin")
path+=("$HOME/.bun/bin")
path+=("$HOME/go/bin")
path+=("$HOME/.cargo/bin")
path+=("$HOME/.dotnet/tools")
typeset -U path

# ────────────────────────────────────────────────────────────────
# Integrations
# ────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"