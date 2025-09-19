#!/usr/bin/env fish

# XDG Base Directory Specification
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_STATE_HOME "$HOME/.local/state"

# Disable files
set -Ux LESSHISTFILE -

# Fixing paths
set -Ux ZDOTDIR "$XDG_CONFIG_HOME/zsh"
set -Ux NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
set -Ux NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -Ux CARGO_HOME "$XDG_DATA_HOME/cargo"
set -Ux RUST_HOME "$XDG_DATA_HOME/rustup"
set -Ux GRADLE_USER_HOME "$XDG_DATA_HOME/gradle"
set -Ux LEIN_HOME "$XDG_DATA_HOME/lein"
set -Ux PSQL_HISTORY "$XDG_DATA_HOME/psql_history"
set -Ux PYTHON_HISTORY "$XDG_DATA_HOME/python_history"
set -Ux PYTHONSTARTUP "$XDG_CONFIG_HOME/python/startup.py"
set -Ux MPLCONFIGDIR "$XDG_CONFIG_HOME/matplotlib"
set -Ux MATPLOTLIBRC "$XDG_CONFIG_HOME/matplotlib"
set -Ux DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -Ux WINEPREFIX "$XDG_DATA_HOME/wineprefixes/default"
set -Ux BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundle"
set -Ux BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME/bundle"
set -Ux BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundle"
set -Ux GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -Ux PYENV_ROOT "$XDG_DATA_HOME/pyenv"

# Add to PATH
test -d $PYENV_ROOT/bin; and fish_add_path $PYENV_ROOT/bin

echo "✅ Universal variables set!"
