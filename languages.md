# Language Servers, Formatters, Linters, and More

This file is for setting up language servers and other language tools for
Neovim. It is created as a markdown file instead of a script for flexibility
in setting up language servers depending on current needs.

To use this file, follow the instructions in each installation section.

## Prerequisites

All executables used to install the language servers, formatters, and linters
in this file are in `Brewfile` and should already be installed. If not, follow
the instructions in the Installation section of the README to install Homebrew
and the necessary packages.

## Bash/Zsh

### bash-language-server

```bash
npm i -g bash-language-server
```

### shfmt

```bash
# macOS
brew install shfmt
```

## C

### clangd

```bash
# macOS
brew install llvm
```

## CSS

### vscode-css-language-server

```bash
npm i -g vscode-langservers-extracted
```

## Docker

### docker-langserver

```bash
npm i -g dockerfile-language-server-nodejs
```

### hadolint

```bash
# macOS
brew install hadolint
```

## ESLint

### vscode-eslint-language-server

```bash
npm i -g vscode-langservers-extracted
```

## HTML

### vscode-html-language-server

```bash
npm i -g vscode-langservers-extracted
```

## Java

### jdtls

```bash
# macOS
brew install jdtls
```

### java-debug

Clone the [java-debug](https://github.com/microsoft/java-debug.git) repository
(can be anywhere, but I chose `$XDG_DATA_HOME/java-debug`):

```bash
git clone https://github.com/microsoft/java-debug.git "$XDG_DATA_HOME/java-debug"
cd "$XDG_DATA_HOME/java-debug"
```

Then, build the project with:

```bash
./mvnw clean install
```

After running the command, the JAR file for the debug adapter should be
located at `com.microsoft.java.debug.plugin/target/`.

### lombok

`jdtls` does not support Lombok out of the box, so you need to install Lombok
and have `jdtls` load it.

[Download](https://projectlombok.org/download) the Lombok JAR file. After
downloading, move the JAR file:

```bash
mkdir -p "$XDG_DATA_HOME/java"
mv /path/to/lombok.jar "$XDG_DATA_HOME/java/lombok.jar"
```

## JavaScript/TypeScript

### tsgo

```bash
npm i -g @typescript/native-preview
```

## JSON

### vscode-json-language-server

```bash
npm i -g vscode-langservers-extracted
```

## Lua

### lua-language-server

```bash
# macOS
brew install lua-language-server
```

## Markdown

### markdownlint-cli2

```bash
# macOS
brew install markdownlint-cli2
```

### markdown-toc

```bash
npm i -g markdown-toc
```

## Prettier

### prettier

```bash
brew install prettier
```

### Prettierd

```bash
brew install prettierd
```

## Python

### ty

```bash
# macOS
brew install ty
```

### ruff

```bash
# macOS
brew install ruff
```

## Stylelint

### stylelint-language-server

```bash
npm i -g @stylelint/language-server
```

## TOML

### taplo

```bash
# macOS
brew install taplo
```

## XML

Download the binary from [vscode-xml](https://github.com/redhat-developer/vscode-xml/releases).

After downloading, move the binary to a directory in your PATH
(e.g., `$HOME/.local/bin/`). Then, create a symlink in the same directory
called `lemminx` that points to the binary:

```bash
ln -s /path/to/binary /path/to/lemminx
```

## YAML

```bash
npm i -g yaml-language-server
```
