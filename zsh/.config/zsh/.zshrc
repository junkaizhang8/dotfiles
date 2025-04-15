# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# EXPORTS
# ==============================================================================

# zim
export ZIM_HOME="$XDG_DATA_HOME/zim"

# zsh-autosuggestions
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
export HISTDIR="$XDG_STATE_HOME/zsh/history"
export HISTFILE="$HISTDIR/.zsh_history"
export HISTFILE_BACKUP="$HISTDIR/.zsh_history.backup"

# ls colors
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:fi=93'

# Personal scripts
export SCRIPTS="$HOME/scripts"

# pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# fnm
export FNM_PATH="$XDG_DATA_HOME/fnm"

# bat
export BAT_THEME=tokyonight_night

# yazi
export EDITOR="nvim"

# ==============================================================================
# ZIM
# ==============================================================================

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/Cellar/zimfw/1.17.1/share/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ==============================================================================
# CONFIGURATIONS
# ==============================================================================

[ -f "${ZDOTDIR}/.p10k.zsh" ] && source "${ZDOTDIR}/.p10k.zsh"
[ -f "${XDG_CONFIG_HOME}/fzf/fzf.zsh" ] && source "${XDG_CONFIG_HOME}/fzf/fzf.zsh"

# ==============================================================================
# ZSH AUTOSUGGESTIONS
# ==============================================================================

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ==============================================================================
# FZF
# ==============================================================================

fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --icons=always --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
show_file_or_dir_preview_zstyle='if [ -d $realpath ]; then eza --tree --icons=always --color=always $realpath | head -200; else bat -n --color=always --line-range :500 $realpath; fi'

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},border:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan} --layout reverse --border --bind tab:accept"

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
# PATH
# ==============================================================================

# Personal scripts
if [ -d "$SCRIPTS" ]; then
  case ":$PATH:" in
    *":$SCRIPTS:"*) ;;
    *) export PATH="$SCRIPTS:$PATH" ;;
  esac
fi

# pyenv
if [ -d "$PYENV_ROOT" ]; then
  case ":$PATH:" in
    *":$PYENV_ROOT/bin:"*) ;;
    *) export PATH="$PYENV_ROOT/bin:$PATH" ;;
  esac
fi

# pnpm
if [ -d "$PNPM_HOME" ]; then
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

# fnm
if [ -d "$FNM_PATH" ]; then
  case ":$PATH:" in
    *":$FNM_PATH:"*) ;;
    *) export PATH="$FNM_PATH:$PATH" ;;
  esac
fi

# ==============================================================================
# SHELL INTEGRATIONS
# ==============================================================================

eval "$(fzf --zsh)"
eval "${$(zoxide init --cmd cd zsh):s#_files -/#_cd#}"
# eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"

# pyenv init --path (removed rehashing)
PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
for i in ${!paths[@]}; do 
if [[ ${paths[i]} == "''${XDG_DATA_HOME}/pyenv/shims''" ]]; then unset '\''paths[i]'\''; 
fi; done; 
echo "${paths[*]}"')"
export PATH="${XDG_DATA_HOME}/pyenv/shims:${PATH}"

# pyenv init - zsh (removed rehashing)
PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
for i in ${!paths[@]}; do 
if [[ ${paths[i]} == "''${XDG_DATA_HOME}/pyenv/shims''" ]]; then unset '\''paths[i]'\''; 
fi; done; 
echo "${paths[*]}"')"
export PATH="${XDG_DATA_HOME}/pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
source '/opt/homebrew/Cellar/pyenv/2.5.3/completions/pyenv.zsh'
pyenv() {
  local command=${1:-}
  [ "$#" -gt 0 ] && shift
  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}

# ==============================================================================
# KEY BINDINGS
# ==============================================================================

bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^ ' autosuggest-accept

# Rebind fzf-cd-widget to Ctrl+Z
bindkey -r '\ec'
bindkey '^z' fzf-cd-widget

# ==============================================================================
# ALIASES
# ==============================================================================

alias reload='exec zsh'
alias zshrc='code "$ZDOTDIR/.zshrc"'
alias zshenv='code "$HOME/.zshenv"'
alias utsc='cd "$HOME/utsc-schoolwork"'
alias npm='pnpm'
alias npx='pnpx'
alias c='clear'
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
alias cat='bat'
alias vi='nvim'
alias v='nvim'
alias cwd='echo -n $PWD | pbcopy'
alias dsp='docker system prune -f'
alias regex='v -MR "$HOME/cheatsheets/regex.txt"'
alias bs='browser-sync start --server --no-online --files="**/*"'
alias lg='lazygit'
alias ld='lazydocker'
alias fetch='fastfetch'

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
