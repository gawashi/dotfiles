# Design: C++ Rules Integration into Dotfiles

**Date:** 2026-03-21
**Status:** Approved

## Overview

Incorporate C++ coding rules and common rules from [everything-claude-code](https://github.com/affaan-m/everything-claude-code) into `dotfiles/.claude/rules/`, and update `install.sh` to support recursive, file-level symlinking for both rules and skills.

## Goals

- Add C++ and common rules from everything-claude-code to dotfiles for version control and portability
- Ensure plugin/tool-added files in `~/.claude/rules/` and `~/.claude/skills/` are not accidentally tracked in dotfiles git
- Keep rules customizable (static copy, not a submodule)

## File Structure

Files to add under `dotfiles/.claude/rules/`:

```
dotfiles/.claude/rules/
├── common/
│   ├── agents.md
│   ├── coding-style.md
│   ├── development-workflow.md
│   ├── git-workflow.md
│   ├── hooks.md
│   ├── patterns.md
│   ├── performance.md
│   ├── security.md
│   └── testing.md
└── cpp/
    ├── coding-style.md
    ├── hooks.md
    ├── patterns.md
    ├── security.md
    └── testing.md
```

Source: `rules/common/` and `rules/cpp/` from everything-claude-code (static copy).

## Symlink Strategy

`~/.claude/rules/` and `~/.claude/skills/` directories are **real directories** (not symlinks). Each `.md` file inside is symlinked individually to its counterpart in dotfiles.

```
~/.claude/rules/common/coding-style.md → dotfiles/.claude/rules/common/coding-style.md
~/.claude/rules/cpp/coding-style.md    → dotfiles/.claude/rules/cpp/coding-style.md
```

Subdirectories in `~/.claude/rules/` and `~/.claude/skills/` are created with `mkdir -p` as real directories. This ensures files added by plugins or other tools remain outside dotfiles git tracking.

## install.sh Changes

### `install_claude_rules`

Replace the current flat `*.md` glob loop with a `find`-based recursive loop:

1. Find all `.md` files under `dotfiles/.claude/rules/` recursively
2. For each file, compute its relative path from the rules source dir
3. Create the target subdirectory in `~/.claude/rules/` with `mkdir -p`
4. Create a symlink from the target path to the source file

### `install_claude_skills`

Apply the same recursive approach to `install_claude_skills`, replacing the flat `*.md` glob loop with identical `find`-based logic targeting `dotfiles/.claude/skills/` → `~/.claude/skills/`.

## What Does NOT Change

- `~/.claude/rules/` and `~/.claude/skills/` are not symlinked as whole directories
- Files added by plugins or `claude plugin install` remain untracked by dotfiles git
- No submodule or network dependency is introduced; rules are a static copy
