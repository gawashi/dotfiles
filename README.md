# dotfiles

Personal dotfiles for Linux and Windows (WSL2/PowerShell). Shell configs, editor settings, installers, and Claude Code customizations to quickly set up a development environment.

## What's Included

- `.bashrc` — enhanced bash configuration with custom prompts and settings
- `.bash_aliases` — shell aliases for navigation, git, and common commands
- `.bash_profile` — bash profile configuration
- `.vimrc` — vim editor configuration with sensible defaults
- `.tmux.conf` — tmux terminal multiplexer configuration
- `.gitignore` — global gitignore patterns
- `.claude/` — Claude Code skills, rules, and local settings
- `Microsoft.PowerShell_profile.ps1` — PowerShell profile for Windows
- `install.sh` — Linux installer with symlinks and plugin setup
- `install.ps1` — Windows installer

## Quick Install - Linux

```bash
git clone https://github.com/gawashi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Quick Install - Windows (PowerShell)

```powershell
git clone https://github.com/gawashi/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\install.ps1
```

## Installation Options (Linux)

```
Usage: ./install.sh [OPTIONS]
Options:
  -h, --help       Show this help message
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

## Claude Code

### Skills

- `brainstorm` — general-purpose brainstorming assistant for any non-software topic
- `create-github-issue` — creates a GitHub Issue to capture a design deficiency or oversight without interrupting the current task
- `tech-qa` — answers technical questions by researching authoritative sources

### Rules

`.claude/rules/` exists for project-specific rules (currently empty).

### Plugins

Installed via `claude plugin install`:

- `superpowers` — skill framework and workflow enhancements ([GitHub](https://github.com/obra/superpowers))
- `context7` — library documentation lookup ([GitHub](https://github.com/upstash/context7))
- `serena` — semantic code analysis and editing ([GitHub](https://github.com/oraios/serena))
- `skill-creator` — create and manage custom skills ([GitHub](https://github.com/anthropics/claude-plugins-official))

### GSD

Installed via `npx get-shit-done-cc@latest` — project management and execution framework for Claude Code ([GitHub](https://github.com/gsd-build/get-shit-done)).
