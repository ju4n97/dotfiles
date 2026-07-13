# ================================================================
# mise 
# ================================================================
eval "$(mise activate zsh)"

# ================================================================
# PATH
# ================================================================
path+=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.dotnet/tools"
  "$GOBIN" 
)
typeset -U path

# ================================================================
# Prompt
# ================================================================
eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.json")"

# ================================================================
# Zinit bootstrap
# ================================================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME/.git" ]]; then
    mkdir -p "${ZINIT_HOME:h}"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ================================================================
# Completion plugins
# ================================================================
zinit light zsh-users/zsh-completions

# ================================================================
# Completion system
# ================================================================
autoload -Uz compinit
compinit -C

# ================================================================
# fzf-tab
# ================================================================
zinit light Aloxaf/fzf-tab

# ================================================================
# Plugins
# ================================================================
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

zinit cdreplay -q

# ================================================================
# Bun completions
# ================================================================
[[ -f "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# ================================================================
# fzf / zoxide
# ================================================================
eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)"

# ================================================================
# Keybindings (vi mode)
# ================================================================
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

autoload -Uz history-search-end

zle -N history-search-backward-end history-search-backward-end
zle -N history-search-forward-end history-search-forward-end

bindkey '^P' history-search-backward-end
bindkey '^N' history-search-forward-end

vi-yank-clipboard() {
    zle vi-yank
    print -rn -- "$CUTBUFFER" | xclip -selection clipboard
}

zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# ================================================================
# History
# ================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

setopt \
    APPEND_HISTORY \
    SHARE_HISTORY \
    HIST_IGNORE_SPACE \
    HIST_IGNORE_ALL_DUPS \
    HIST_SAVE_NO_DUPS \
    HIST_IGNORE_DUPS \
    HIST_FIND_NO_DUPS

# ================================================================
# Aliases
# ================================================================
alias ls='ls --color=auto'
alias la='ls --color=auto -la'
alias task='go-task'
alias dumpfiles="$HOME/.local/bin/dumpfiles.sh"

expand-alias() {
    zle _expand_alias
}

zle -N expand-alias
bindkey '^ ' expand-alias