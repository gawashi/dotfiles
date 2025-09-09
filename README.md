# dotfiles

Personal dotfiles configuration for Linux systems. This repository contains my shell configurations, vim settings, tmux configuration, and other dotfiles to quickly set up a development environment.

## 📋 What's Included

- **`.bashrc`** - Enhanced bash configuration with custom prompts and settings
- **`.bash_aliases`** - Convenient shell aliases for navigation, git, and common commands
- **`.bash_profile`** - Bash profile configuration
- **`.vimrc`** - Vim editor configuration with sensible defaults
- **`.tmux.conf`** - tmux terminal multiplexer configuration
- **`.gitignore`** - Global gitignore patterns
- **`.claude/`** - Claude Code custom commands and configurations

## 🚀 Quick Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## 📦 Installation Options

The install script supports several options:

```bash
./install.sh [OPTIONS]

Options:
  -h, --help       Show help message
  -f, --force      Force overwrite existing files without backup
  -y, --yes        Skip confirmation prompts
  -d, --dry-run    Show what would be done without making changes
  -b, --backup     Create backup even in dry-run mode

Examples:
  ./install.sh                 # Interactive mode with backup
  ./install.sh -y              # Auto-confirm all actions
  ./install.sh -d              # See what would be installed
  ./install.sh -f -y           # Force install without prompts
```

## 🔧 Manual Setup

If you prefer manual installation:

```bash
# Backup existing files
cp ~/.bashrc ~/.bashrc.backup
cp ~/.vimrc ~/.vimrc.backup

# Copy dotfiles
cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases
cp .bash_profile ~/.bash_profile
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf

# Reload bash configuration
source ~/.bashrc
```
