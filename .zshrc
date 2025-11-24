# Init Oh My Posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.json)"

# Init Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add snippets
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings (vi mode)
bindkey -v
bindkey -M viins jk vi-cmd-mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Yank to the system clipboard
function vi-yank-clipboard {
  zle vi-yank
  echo "$CUTBUFFER" | xclip -selection clipboard
}

zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
setopt aliases
alias ls='ls --color'
alias la='ls --color -la'
alias task='go-task'
alias dumpfiles='$HOME/.local/bin/dumpfiles.sh'
function expand-alias() {
  zle _expand_alias
  zle self-insert
}
zle -N expand-alias
bindkey '^@' expand-alias

# Aliases - Open WebUI
alias owui='xdg-open http://localhost:8080'
alias owui-install='docker pull ghcr.io/open-webui/open-webui:main'
alias owui-run='docker run -d --network host -e OLLAMA_BASE_URL=http://127.0.0.1:11434 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main'
alias owui-update='docker stop open-webui && docker rm open-webui && docker pull ghcr.io/open-webui/open-webui:main && owui-run'
alias owui-stop='docker stop open-webui'
alias owui-remove='docker rm open-webui'
alias owui-logs='docker logs open-webui'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# go
export GO_INSTALL="$HOME/go"
export PATH="$GO_INSTALL/bin:$PATH"

# cargo
export CARGO_INSTALL="$HOME/.cargo"
export PATH="$CARGO_INSTALL/bin:$PATH"

# dotnet
export DOTNET_INSTALL="$HOME/.dotnet"
export PATH="$DOTNET_INSTALL/tools:$PATH"

# pipx
export PIPX_HOME="$HOME/.local/share/pipx/venvs"
export PATH="$HOME/.local/bin:$PATH"

# fcitx
export GTK_IM_MODULE='fcitx'
export QT_IM_MODULE='fcitx'
export SDL_IM_MODULE='fcitx'
export XMODIFIERS='@im=fcitx'