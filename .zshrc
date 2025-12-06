eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.json")"

# ================================================================
# Zinit bootstrap
# ================================================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && mkdir -p "${ZINIT_HOME%/*}"
[[ ! -d "$ZINIT_HOME/.git" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

# ================================================================
# Completion plugins
# ================================================================
zinit light zsh-users/zsh-completions
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ================================================================
# Completion system initialization
# ================================================================
autoload -Uz compinit
compinit -C

# ================================================================
# fzf-tab
# ================================================================
zinit ice lucid
zinit light Aloxaf/fzf-tab

# ================================================================
# Heavy plugins
# ================================================================
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

zinit cdreplay -q

# ================================================================
# Keybindings (vi mode)
# ================================================================
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

# ================================================================
# History
# ================================================================
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

setopt appendhistory sharehistory \
       hist_ignore_space hist_ignore_all_dups \
       hist_save_no_dups hist_ignore_dups hist_find_no_dups

# ================================================================
# Aliases
# ================================================================
alias ls='ls --color'
alias la='ls --color -la'
alias task='go-task'
alias dumpfiles="$HOME/.local/bin/dumpfiles.sh"

expand-alias() { zle _expand_alias; }
zle -N expand-alias
bindkey '^@' expand-alias

# ================================================================
# PATH
# ================================================================
path+=(
  "$HOME/.local/bin" 
  "$HOME/.bun/bin" 
  "$HOME/.cargo/bin" 
  "$HOME/.dotnet/tools"
  "$HOME/go/bin" 
)
typeset -U path

# ================================================================
# Integrations
# ================================================================
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
