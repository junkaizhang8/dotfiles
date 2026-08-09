# Dotfiles

This repository contains my personal configuration files for various applications.

## Installation

Clone the directory:

```bash
git clone https://github.com/junkaizhang8/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

If this is not a fresh install, you may skip the Homebrew installation step.
Otherwise, install [Homebrew](https://brew.sh/) with the command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After that is done, install `git` and `stow` with Homebrew:

```bash
brew install git stow
```

Then, run the following script to symlink the configuration files to your home directory:

```bash
./stow.sh

# For more information on the script and its options
./stow.sh --help
```

This is done so that when we install packages later, the configuration files
will already be in place, so you won't have to deal with deleting any
auto-generated configuration files.

Finally, install the packages listed in the `Brewfile` with the command:

```bash
brew bundle
```

Some packages may not be available on Homebrew or use their own installation
method. For these packages, follow the instructions in `deps.md` to install them.

## Language Servers, Formatters, Linters, and More

To set up language servers, formatters, linters, and other language tools for
Neovim, follow the instructions in `languages.md`.

## Scripts

Utility scripts can be found under the `scripts/Scripts/` directory. If you
want to add local scripts, put them in `scripts/Scripts/local/` (you may need
to make that directory) so they are ignored by git. By default, `stow.sh` will
symlink `scripts/Scripts/` to `Scripts/` in your home directory.
