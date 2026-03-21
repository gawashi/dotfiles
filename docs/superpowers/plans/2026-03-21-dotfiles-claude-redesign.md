# Dotfiles Claude Code Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure dotfiles so GSD and Claude Code plugin files are never tracked in git — only user-authored skills and rules are managed via individual symlinks.

**Architecture:** Remove the directory-level symlinks for `~/.claude/agents` and `~/.claude/commands`. Replace the `handle_claude_directory` logic in `install.sh` with individual symlink functions for `skills/` and `rules/`. Tool installs (GSD, Claude plugins) are declared explicitly in `install.sh`.

**Tech Stack:** bash, git, npx, Claude Code CLI (`claude`)

**Spec:** `docs/superpowers/specs/2026-03-21-dotfiles-claude-redesign.md`

---

## Key facts before starting

- `~/.claude/agents` and `~/.claude/commands` are currently **symlinks** pointing into dotfiles (not real dirs)
- Nothing under `dotfiles/.claude/` is currently tracked in git (all untracked `??`)
- `*.local.json` is gitignored in dotfiles — `settings.local.json` won't be git-tracked unless force-added
- GSD files in `dotfiles/.claude/agents/` and `dotfiles/.claude/commands/gsd/` were **never committed** — no `git rm --cached` needed

---

## File map

| File | Action |
|------|--------|
| `dotfiles/install.sh` | Modify — replace claude handling logic |
| `dotfiles/.claude/agents/` | Delete entirely |
| `dotfiles/.claude/commands/` | Delete entirely |
| `dotfiles/.claude/skills/.gitkeep` | Create |
| `dotfiles/.claude/rules/.gitkeep` | Create |

---

## Task 1: Delete tool-managed directories from dotfiles

**Files:**
- Delete: `dotfiles/.claude/agents/`
- Delete: `dotfiles/.claude/commands/`

- [ ] **Step 1: Verify nothing in these directories is git-tracked**

```bash
git -C ~/dotfiles ls-files .claude/agents .claude/commands
```

Expected: no output (nothing tracked)

- [ ] **Step 2: Delete the directories**

```bash
rm -rf ~/dotfiles/.claude/agents ~/dotfiles/.claude/commands
```

- [ ] **Step 3: Verify deletion**

```bash
ls ~/dotfiles/.claude/
```

Expected: only `settings.local.json` remains

---

## Task 2: Create skills/ and rules/ scaffolding

**Files:**
- Create: `dotfiles/.claude/skills/.gitkeep`
- Create: `dotfiles/.claude/rules/.gitkeep`

- [ ] **Step 1: Create directories with .gitkeep**

```bash
mkdir -p ~/dotfiles/.claude/skills ~/dotfiles/.claude/rules
touch ~/dotfiles/.claude/skills/.gitkeep ~/dotfiles/.claude/rules/.gitkeep
```

- [ ] **Step 2: Verify**

```bash
ls ~/dotfiles/.claude/
```

Expected: `rules/  settings.local.json  skills/`

---

## Task 3: Rewrite install.sh claude handling

**Files:**
- Modify: `~/dotfiles/install.sh`

Remove `handle_claude_subdirectory()` and `handle_claude_directory()` functions entirely. Add three new functions: `install_claude_symlink` (for individual file symlinks), `install_claude_skills`, `install_claude_rules`. Add tool install section at end of `main()`.

- [ ] **Step 1: Remove `handle_claude_subdirectory` function**

Remove lines from `handle_claude_subdirectory()` through its closing `}` (currently lines 86–135).

- [ ] **Step 2: Remove `handle_claude_directory` function**

Remove lines from `handle_claude_directory()` through its closing `}` (currently lines 137–155).

- [ ] **Step 3: Add new helper function `install_claude_symlink` after `install_file()`**

Add the following after the `install_file()` function (before `confirm()`):

```bash
install_claude_symlink() {
    local source="$1"
    local target="$2"
    local label="$3"

    local parent_dir
    parent_dir="$(dirname "$target")"
    if [[ ! -d "$parent_dir" && "$DRY_RUN" == false ]]; then
        mkdir -p "$parent_dir"
    fi

    if [[ "$DRY_RUN" == false ]]; then
        ln -sf "$source" "$target"
        log_success "Linked $label"
    else
        log_info "Would link $label -> $source"
    fi
}

install_claude_skills() {
    local skills_source="$BASEDIR/.claude/skills"
    local skills_target="$HOME/.claude/skills"

    if [[ ! -d "$skills_source" ]]; then
        return 0
    fi

    for file in "$skills_source"/*.md; do
        [[ -f "$file" ]] || continue
        local filename
        filename="$(basename "$file")"
        install_claude_symlink "$(realpath "$file")" "$skills_target/$filename" ".claude/skills/$filename"
    done
}

install_claude_rules() {
    local rules_source="$BASEDIR/.claude/rules"
    local rules_target="$HOME/.claude/rules"

    if [[ ! -d "$rules_source" ]]; then
        return 0
    fi

    for file in "$rules_source"/*.md; do
        [[ -f "$file" ]] || continue
        local filename
        filename="$(basename "$file")"
        install_claude_symlink "$(realpath "$file")" "$rules_target/$filename" ".claude/rules/$filename"
    done
}

install_tools() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Would install Claude Code plugins (superpowers, context7, serena)"
        log_info "Would install GSD via npx get-shit-done-cc@latest"
        return 0
    fi

    log_info "Installing Claude Code plugins..."
    # Note: verify exact syntax with 'claude plugin --help' if this fails
    if command -v claude &>/dev/null; then
        claude plugin install superpowers@claude-plugins-official || true
        claude plugin install context7@claude-plugins-official || true
        claude plugin install serena@claude-plugins-official || true
        log_success "Claude plugins installed"
    else
        log_warning "claude CLI not found — skipping plugin installs"
    fi

    log_info "Installing GSD..."
    if command -v npx &>/dev/null; then
        npx get-shit-done-cc@latest
        log_success "GSD installed"
    else
        log_warning "npx not found — skipping GSD install"
    fi
}
```

- [ ] **Step 4: Update `main()` — replace old `.claude` block with new calls**

Find this block in `main()`:

```bash
    # Handle .claude directory specially
    if [[ -d ".claude" ]]; then
        if confirm "Process .claude directory?"; then
            handle_claude_directory
        else
            log_info "Skipping .claude directory"
        fi
    fi
```

Replace with:

```bash
    # Handle .claude skills and rules
    if [[ -d ".claude" ]]; then
        if confirm "Install Claude Code skills and rules?"; then
            mkdir -p "$HOME/.claude/skills" "$HOME/.claude/rules"
            install_claude_skills
            install_claude_rules
        else
            log_info "Skipping Claude Code skills and rules"
        fi
    fi
```

- [ ] **Step 5: Add tool installs at end of `main()`, before the "Next steps" echo block**

Add before the `# Show next steps` comment:

```bash
    # Install tools
    if confirm "Install Claude Code plugins and GSD?"; then
        install_tools
    else
        log_info "Skipping tool installs"
    fi
```

- [ ] **Step 6: Verify no dangling references to old functions**

```bash
grep -n 'handle_claude' ~/dotfiles/install.sh
```

Expected: no output

- [ ] **Step 7: Run dry-run to verify no syntax errors**

```bash
bash -n ~/dotfiles/install.sh && echo "syntax OK"
~/dotfiles/install.sh --dry-run --yes 2>&1 | head -40
```

Expected: "syntax OK" and dry-run output showing what would be linked (no actual tool installs run)

---

## Task 4: Migrate live ~/.claude/

Break the current symlinks and replace with real directories so GSD and plugins can write into them freely.

- [ ] **Step 1: Confirm current state — agents and commands are symlinks**

```bash
ls -la ~/.claude/agents ~/.claude/commands
```

Expected: both show as `lrwxrwxrwx` symlinks pointing to `~/dotfiles/.claude/...`

- [ ] **Step 2: Remove the symlinks**

```bash
rm ~/.claude/agents ~/.claude/commands
```

Note: `rm` on a symlink removes only the link, not the target. Safe.

- [ ] **Step 3: Recreate as real directories**

```bash
mkdir -p ~/.claude/agents ~/.claude/commands
```

- [ ] **Step 4: Verify**

```bash
ls -la ~/.claude/agents ~/.claude/commands
```

Expected: both are real directories (not symlinks)

- [ ] **Step 5: Reinstall GSD to repopulate agents and commands**

```bash
npx get-shit-done-cc@latest
```

Expected: GSD installs its `gsd-*.md` agents and `gsd/` commands into the now-real directories

- [ ] **Step 6: Verify GSD files are back**

```bash
ls ~/.claude/agents/ | head -5
ls ~/.claude/commands/ | head -5
```

Expected: `gsd-*.md` files in agents/, `gsd/` dir in commands/

---

## Task 5: Commit

- [ ] **Step 1: Check git status — only expected files**

```bash
git -C ~/dotfiles status --short
```

Expected:
- `?? .claude/rules/.gitkeep` (new)
- `?? .claude/skills/.gitkeep` (new)
- `?? docs/` (new)
- No `?? .claude/agents/` or `?? .claude/commands/`

- [ ] **Step 2: Stage changes**

Note: `docs/` includes the spec and plan files — these are intentionally committed as part of this change.

```bash
git -C ~/dotfiles add .claude/skills/.gitkeep .claude/rules/.gitkeep install.sh docs/
```

- [ ] **Step 3: Commit**

```bash
git -C ~/dotfiles commit -m "refactor: manage only user-authored .claude content in dotfiles

- Remove agents/ and commands/ from dotfiles (tool-managed by GSD/plugins)
- Add skills/ and rules/ directories for user-authored content
- Rewrite install.sh: individual symlinks for skills/rules, declare tool installs
- Tool installs (GSD, Claude plugins) are now explicit in install_tools()"
```

- [ ] **Step 4: Verify clean state**

```bash
git -C ~/dotfiles status
```

Expected: `nothing to commit, working tree clean` (or only untracked files that should stay untracked)
