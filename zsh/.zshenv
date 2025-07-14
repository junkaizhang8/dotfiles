typeset -U path

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Disable files
export LESSHISTFILE=-

# Fixing paths
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUST_HOME="$XDG_DATA_HOME/rustup"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export LEIN_HOME="$XDG_DATA_HOME/lein"
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python_history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"
export MATPLOTLIBRC="$XDG_CONFIG_HOME/matplotlib"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# Rust
. "$CARGO_HOME/env"
