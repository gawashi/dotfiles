# README.md Update Design

## Context

The current README.md is outdated. It doesn't reflect PowerShell/Windows support, Claude Code skills/rules/plugins, or the correct GitHub clone URL. This spec defines the updated content.

## Target Audience

The author (future self) — a personal reference for setting up the development environment.

## Style

- English
- No emojis in headings
- Flat structure (no nested subsections beyond Claude Code)

## Structure

### Section 1: Header + What's Included

Opening paragraph updated to mention Linux and Windows (WSL2/PowerShell). File list updated to include:

- `.bashrc`, `.bash_aliases`, `.bash_profile`, `.vimrc`, `.tmux.conf`, `.gitignore` (existing)
- `.claude/` — described as "skills, rules, and local settings" (updated description)
- `Microsoft.PowerShell_profile.ps1` — PowerShell profile (new)
- `install.sh` — Linux installer with symlinks + plugins (new description)
- `install.ps1` — Windows installer (new)

### Section 2: Quick Install - Linux / Windows

Two subsections with clone + run commands:

- Linux: `git clone` to `~/dotfiles`, run `./install.sh`
- Windows (PowerShell): `git clone` to `$HOME\dotfiles`, run `.\install.ps1`

Clone URL: `https://github.com/gawashi/dotfiles.git`

### Section 3: Installation Options (Linux)

Reproduces `install.sh --help` output: flags `-h`, `-f`, `-y`, `-d`, `-b` with examples. Scoped to Linux only (install.ps1 has no options).

### Section 4: Claude Code

Four parts:

- **Skills**: `brainstorm`, `create-github-issue`, `tech-qa` with one-line descriptions
- **Rules**: Note that `.claude/rules/` exists for project-specific rules (currently empty)
- **Plugins** (via `claude plugin install`), each with a one-line description and links to docs/GitHub:
  - `superpowers` — skill framework and workflow enhancements ([GitHub](https://github.com/obra/superpowers))
  - `context7` — library documentation lookup ([GitHub](https://github.com/upstash/context7))
  - `serena` — semantic code analysis and editing ([GitHub](https://github.com/oraios/serena))
  - `skill-creator` — create and manage custom skills ([GitHub](https://github.com/anthropics/claude-plugins-official))
- **GSD**: Separate tool installed via `npx get-shit-done-cc@latest` — project management and execution framework for Claude Code ([GitHub](https://github.com/gsd-build/get-shit-done))

### Removed

- Manual Setup section (not needed — install script covers this)
- Emoji headings
