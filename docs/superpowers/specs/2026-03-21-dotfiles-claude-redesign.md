# Dotfiles Claude Code Redesign

**Date:** 2026-03-21
**Status:** Approved

## Problem

The current dotfiles setup symlinks entire `~/.claude/agents/` and `~/.claude/commands/` directories to the dotfiles repo. Tools like GSD (npx) and Claude Code plugins write files into these directories, which surfaces as untracked files in git. This pollutes the dotfiles repo with tool-managed content.

## Goal

Manage only user-authored content in dotfiles. Tool-managed content (GSD agents/commands, plugin files, `settings.json`) is declared via install commands in `install.sh`, not tracked as files. User-authored content (`settings.local.json`, skills, rules) is tracked via individual symlinks.

## What dotfiles manages

| File | Source in dotfiles | Target | Method |
|------|--------------------|--------|--------|
| Custom skills | `dotfiles/.claude/skills/<file>` | `~/.claude/skills/<file>` | Individual symlinks |
| Custom rules | `dotfiles/.claude/rules/<file>` | `~/.claude/rules/<file>` | Individual symlinks |
| GSD | — | — | `npx get-shit-done-cc@latest` in `install.sh` |
| Claude plugins | — | — | `claude plugin install <name>` in `install.sh` |

Note: `dotfiles/.claude/settings.local.json` remains in the repo as a **project-level** Claude Code setting (applies only when working inside the dotfiles directory). It is NOT symlinked globally to `~/.claude/settings.local.json`.

## What dotfiles does NOT manage

| Content | Who manages it |
|---------|---------------|
| `~/.claude/settings.json` | GSD + Claude Code plugins (auto-written) |
| `~/.claude/agents/gsd-*.md` | GSD |
| `~/.claude/commands/gsd/` | GSD |
| `~/.claude/plugins/` | Claude Code plugin system |

**Reason:** `settings.json` contains `enabledPlugins`, `hooks`, and `statusLine` — all written automatically by tools. Tracking it in dotfiles would recreate the original problem.

## dotfiles directory structure

```
dotfiles/
└── .claude/
    ├── skills/              ← user-authored skills only (add .gitkeep if empty)
    ├── rules/               ← user-authored rules only (add .gitkeep if empty)
    └── settings.local.json  ← project-level setting (not symlinked globally)
```

## install.sh behavior

1. Create `~/.claude/`, `~/.claude/skills/`, `~/.claude/rules/` with `mkdir -p` if missing
2. For each `.md` file in `dotfiles/.claude/skills/`: `ln -sf <source> ~/.claude/skills/<file>`
3. For each `.md` file in `dotfiles/.claude/rules/`: `ln -sf <source> ~/.claude/rules/<file>`
5. Run `claude plugin install` for each plugin (idempotent — safe to re-run if already installed)
   - `claude plugin install superpowers@claude-plugins-official`
   - `claude plugin install context7@claude-plugins-official`
   - `claude plugin install serena@claude-plugins-official`
6. Run `npx get-shit-done-cc@latest` (GSD self-installs its agents/commands into `~/.claude/`)

All steps are idempotent — `install.sh` can be re-run safely. `ln -sf` is used throughout to overwrite any existing symlink or file without error.

## Migration steps

Execute in this order:

1. **Untrack and delete** agent/command directories from dotfiles.
   The GSD files in git status appear as untracked (`??`), meaning they were never committed — skip `git rm` and only delete the directories:
   ```bash
   rm -rf dotfiles/.claude/agents dotfiles/.claude/commands
   ```
   If any files were previously committed, also run first:
   ```bash
   git rm -r --cached .claude/agents .claude/commands
   ```

2. **Remove existing directory symlinks** (not `rm -rf` — these are symlinks, not real dirs):
   ```bash
   rm ~/.claude/agents ~/.claude/commands
   ```

3. **Re-create as real directories:**
   ```bash
   mkdir -p ~/.claude/agents ~/.claude/commands
   ```

4. **Re-run GSD install** so it repopulates agents/commands into the now-real directories:
   ```bash
   npx get-shit-done-cc@latest
   ```
   GSD writes its files on install. Alternatively, launching Claude Code triggers GSD's SessionStart hook which also populates them.

5. Add `dotfiles/.claude/skills/` and `dotfiles/.claude/rules/` with `.gitkeep` placeholders.

6. Update `install.sh` to replace `handle_claude_directory()` / `handle_claude_subdirectory()` with the new individual symlink logic described above.

7. Commit changes.
