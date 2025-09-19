if not status is-interactive
    # Commands to run in interactive sessions can go here
    return 0
end

# Aliases: git
alias gl 'git log --all --graph --pretty=format:"%C(magenta)%h %C(cyan) %an %C(yellow) %ar%C(auto) %D%n%s%n"'
alias gls 'git log --oneline --pretty=format:"%C(magenta)%h%C(auto) %s"'
alias gs 'git status -s'

# Aliases: ls
if type -q eza
    alias ls 'eza --color=always --icons=always'
    alias l ls
    alias ll 'ls -l --git --no-user'
    alias la 'ls -a'
    alias lla 'ls -la --git --no-user'
    alias ldot 'ls -d .*/'
    alias llt 'ls -l --sort=time --git --no-user'
    alias lltr 'ls -lr --sort=time --git --no-user'
    alias llat 'ls -la --sort=time --git --no-user'
    alias llatr 'ls -lra --sort=time --git --no-user'
    alias lsd 'test -n *(N/) && ls -d */ || echo "No directories found"'
    alias lsda 'test -n *(N/) && ls -da -- */ .*/ || echo "No directories found"'
    alias lsf 'ls -f'
    alias lsfa 'ls -fa'
    alias tree 'ls --tree'
end

# Aliases: misc
alias reload 'exec fish'
alias snip 'v "$XDG_CONFIG_HOME/nvim/snippets"'
alias npm pnpm
alias npx pnpx
alias c clear
alias cat bat
alias vi nvim
alias v nvim
alias cwd 'echo -n $PWD | pbcopy'
alias dsp 'docker system prune'
alias regex 'v "$HOME/Cheatsheets/regex"'
alias bs 'browser-sync start --server --no-online --files="**/*"'
alias lg lazygit
alias ld lazydocker
alias fetch fastfetch

# fzf
fzf --fish | source

# zoxide
zoxide init --cmd cd fish | source

pyenv init - fish --no-rehash | source

# Prompt
starship init fish | source
