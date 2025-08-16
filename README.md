# Jun Kai Zhang's Dotfiles

This repository contains my personal configuration files for various applications.

## Requirements

Ensure you have git and [GNU Stow](https://www.gnu.org/software/stow/) installed on your system.

## Installation

```
git clone https://github.com/junkaizhang8/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

To see which directories will be symlinked without modifying your file system, run:

```
./install.sh --dry-run
```

## Scripts

Some personal scripts can be found in the `scripts/Scripts/` directory. If you want to add local scripts, put them in `scripts/Scripts/local/` (you may need to make that directory) so they are ignored by git. By default, `install.sh` will symlink `scripts/Scripts/` to `Scripts/` in your home directory.
