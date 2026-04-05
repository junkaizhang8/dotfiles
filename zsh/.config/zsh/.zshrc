# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# EXPORTS
# ==============================================================================

# zim
export ZIM_HOME="$XDG_DATA_HOME/zim"

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6d7175"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
export HISTDIR="$XDG_STATE_HOME/zsh/history"
export HISTFILE="$HISTDIR/.zsh_history"
export HISTFILE_BACKUP="$HISTDIR/.zsh_history.backup"

# ls colors
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:fi=93'

# Personal scripts
export SCRIPTS="$HOME/scripts/bin"
export SCRIPTS_LOCAL="$HOME/scripts/local/bin"

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# fnm
export FNM_PATH="$XDG_DATA_HOME/fnm"

# bat
export BAT_THEME=tokyonight_night

# Default editor
export EDITOR="nvim"

# Man pager
export MANPAGER="nvim +Man!"

# ==============================================================================
# PATH MANAGEMENT TOOLS
# ==============================================================================

# Ensure unique entries and prioritize custom tool paths
typeset -U path

# Helper to safely prepend directories to PATH
path-add() {
  for dir in "$@"; do
    [[ -d "$dir" ]] && path=("$dir" $path)
  done
}

# Diagnostic tool to show PATH entries with status indicators
path-show() {
  for dir in $path; do
    if [[ "$dir" == *"/com.apple.security.cryptexd/"* ]]; then
      printf "\e[34mℹ\e[0m %s (System/Cryptex)\n" "$dir"
    elif [[ -d "$dir" ]]; then
      printf "\e[32m✔\e[0m %s\n" "$dir"
    else
      printf "\e[31m✘\e[0m %s\n" "$dir"
    fi
  done
}

# ==============================================================================
# PATH SETUP
# ==============================================================================


# . "$HOME/.local/share/../bin/env"
path-add \
  "$FNM_PATH" \
  "$PNPM_HOME" \
  /opt/homebrew/bin \
  "$SCRIPTS" \
  "$SCRIPTS_LOCAL" \
  "$HOME/.local/bin"

# ==============================================================================
# CUSTOM COMPLETIONS
# ==============================================================================

fpath=(
  "$ZDOTDIR/completions.local"
  "$ZDOTDIR/completions"
  $fpath
)

# ==============================================================================
# CONFIGURATIONS & SHELL INTEGRATIONS
# ==============================================================================

# zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/Cellar/zimfw/1.17.1/share/zimfw.zsh init
fi
# Initialize modules
source ${ZIM_HOME}/init.zsh

# Shell tools
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"

# Powerlevel10k
[ -f "${ZDOTDIR}/.p10k.zsh" ] && source "${ZDOTDIR}/.p10k.zsh"

# ==============================================================================
# SHELL OPTIONS
# ==============================================================================

# Autosuggestions
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Autocorrection for mistyped commands
setopt CORRECT

# ==============================================================================
# FZF
# ==============================================================================

fg="#CBE0F0"
bg="-1"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --icons=always --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
show_file_or_dir_preview_zstyle='if [ -d $realpath ]; then eza --tree --icons=always --color=always $realpath | head -200; else bat -n --color=always --line-range :500 $realpath; fi'

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},border:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan} --reverse --border --bind tab:accept"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons=always --color=always {} | head -200'"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1" | sed 's#^./##'
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1" | sed 's#^./##'
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --icons=always --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ==============================================================================
# COMPLETION STYLES
# ==============================================================================

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:complete:*' fzf-preview "$show_file_or_dir_preview_zstyle"
zstyle ':fzf-tab:complete:*' fzf-flags --height 60% --bind tab:accept
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --icons=always --color=always $realpath | head -200'
zstyle ':fzf-tab:complete:ssh:*' fzf-preview 'dig $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --tree --icons=always --color=always $realpath | head -200'

# ==============================================================================
# SESH
# ==============================================================================

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# ==============================================================================
# KEY BINDINGS
# ==============================================================================

bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^Y' autosuggest-accept
bindkey '^I' fzf-completion

bindkey -r '^[A'

# ==============================================================================
# ALIASES
# ==============================================================================

# Aliases: git
alias gl='git log --all --graph --pretty=format:"%C(magenta)%h %C(cyan) %an %C(yellow) %ar%C(auto) %D%n%s%n"'
alias gls='git log --oneline --pretty=format:"%C(magenta)%h%C(auto) %s"'
alias gs='git status -s'

# Aliases: ls
alias ls='eza --color=always --icons=always'
alias l='ls'
alias ll='ls -l --git --no-user'
alias la='ls -a'
alias lla='ls -la --git --no-user'
alias ldot='ls -d .*/'
alias llt='ls -l --sort=time --git --no-user'
alias lltr='ls -lr --sort=time --git --no-user'
alias llat='ls -la --sort=time --git --no-user'
alias llatr='ls -lra --sort=time --git --no-user'
alias lsd='[[ -n *(N/) ]] && ls -d */ || echo "No directories found"'
alias lsda='[[ -n *(N/) ]] && ls -da -- */ .*/ || echo "No directories found"'
alias lsf='ls -f'
alias lsfa='ls -fa'
alias tree='ls --tree'

# Aliases: misc
alias :q='exit' # Bad habit from vim
alias reload='exec zsh'
alias zshrc='v "$ZDOTDIR/.zshrc"'
alias zshenv='v "$HOME/.zshenv"'
alias snip='v "$XDG_CONFIG_HOME/nvim/snippets"'
alias ur='uv run'
alias npm='pnpm'
alias npx='pnpx'
alias c='clear'
alias cat='bat'
alias vi='nvim'
alias v='nvim'
alias cwd='echo -n $PWD | pbcopy'
alias dsp='docker system prune'
alias regex='v "$HOME/Cheatsheets/regex"'
alias bs='browser-sync start --server --no-online --files="**/*"'
alias lg='lazygit'
alias lzd='lazydocker'
alias fetch='fastfetch'
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

# ==============================================================================
# FUNCTIONS
# ==============================================================================

timezsh() {
  local shell=${1-$SHELL}
  for i in $(seq 1 10); do
    /usr/bin/time $shell -i -c exit
  done
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

vf() {
  fd -t f -0 | fzf -m --read0 --print0 --bind 'tab:toggle' | xargs -0 nvim
}


# ==============================================================================
# LOCAL CONFIG (ignored by git)
# ==============================================================================

if [[ -f "${ZDOTDIR}/.zshrc.local" ]]; then
  source "${ZDOTDIR}/.zshrc.local"
fi
