# C++ Rules Dotfiles Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add C++ and common rules from everything-claude-code into `dotfiles/.claude/rules/` as a static copy, and update `install.sh` to symlink rules and skills recursively (file-by-file, not directory-by-directory) to prevent plugin-added files from leaking into dotfiles git tracking.

**Architecture:** Rules files are copied statically from GitHub (affaan-m/everything-claude-code). `install.sh` is updated to walk source directories recursively with `find`, creating real subdirectories at the target and symlinking each `.md` file individually. The same pattern is applied to both `install_claude_rules` and `install_claude_skills`.

**Tech Stack:** Bash, GitHub CLI (`gh`), `find`, `ln -sf`

---

## File Map

| Action | Path | Notes |
|--------|------|-------|
| Create | `.claude/rules/common/agents.md` | copied from everything-claude-code |
| Create | `.claude/rules/common/coding-style.md` | copied |
| Create | `.claude/rules/common/development-workflow.md` | copied |
| Create | `.claude/rules/common/git-workflow.md` | copied |
| Create | `.claude/rules/common/hooks.md` | copied |
| Create | `.claude/rules/common/patterns.md` | copied |
| Create | `.claude/rules/common/performance.md` | copied |
| Create | `.claude/rules/common/security.md` | copied |
| Create | `.claude/rules/common/testing.md` | copied |
| Create | `.claude/rules/cpp/coding-style.md` | copied |
| Create | `.claude/rules/cpp/hooks.md` | copied |
| Create | `.claude/rules/cpp/patterns.md` | copied |
| Create | `.claude/rules/cpp/security.md` | copied |
| Create | `.claude/rules/cpp/testing.md` | copied |
| Modify | `install.sh` | replace `install_claude_skills` and `install_claude_rules` function bodies with recursive find-based versions (match by function name, not line number) |

---

### Task 1: Download common/ rule files

**Files:**
- Create: `.claude/rules/common/agents.md`
- Create: `.claude/rules/common/coding-style.md`
- Create: `.claude/rules/common/development-workflow.md`
- Create: `.claude/rules/common/git-workflow.md`
- Create: `.claude/rules/common/hooks.md`
- Create: `.claude/rules/common/patterns.md`
- Create: `.claude/rules/common/performance.md`
- Create: `.claude/rules/common/security.md`
- Create: `.claude/rules/common/testing.md`

- [ ] **Step 1: Create the common/ directory**

```bash
mkdir -p /home/gawashi/dotfiles/.claude/rules/common
```

- [ ] **Step 2: Download all 9 common rule files via GitHub CLI**

```bash
cd /home/gawashi/dotfiles/.claude/rules/common
for f in agents coding-style development-workflow git-workflow hooks patterns performance security testing; do
    gh api repos/affaan-m/everything-claude-code/contents/rules/common/$f.md \
        --jq '.content' | base64 -d > $f.md
    echo "Downloaded $f.md"
done
```

- [ ] **Step 3: Verify all 9 files exist and are non-empty**

```bash
find /home/gawashi/dotfiles/.claude/rules/common -name "*.md" | wc -l
```

Expected: `9`

```bash
find /home/gawashi/dotfiles/.claude/rules/common -name "*.md" -empty
```

Expected: no output (no empty files).

- [ ] **Step 4: Spot-check content integrity — verify frontmatter and headings are present**

```bash
for f in /home/gawashi/dotfiles/.claude/rules/common/*.md; do
    head -1 "$f" | grep -q "^---" && echo "OK: $f" || echo "FAIL: $f missing frontmatter"
done
```

Expected: all lines print `OK:`.

---

### Task 2: Download cpp/ rule files

**Files:**
- Create: `.claude/rules/cpp/coding-style.md`
- Create: `.claude/rules/cpp/hooks.md`
- Create: `.claude/rules/cpp/patterns.md`
- Create: `.claude/rules/cpp/security.md`
- Create: `.claude/rules/cpp/testing.md`

- [ ] **Step 1: Create the cpp/ directory**

```bash
mkdir -p /home/gawashi/dotfiles/.claude/rules/cpp
```

- [ ] **Step 2: Download all 5 C++ rule files**

```bash
cd /home/gawashi/dotfiles/.claude/rules/cpp
for f in coding-style hooks patterns security testing; do
    gh api repos/affaan-m/everything-claude-code/contents/rules/cpp/$f.md \
        --jq '.content' | base64 -d > $f.md
    echo "Downloaded $f.md"
done
```

- [ ] **Step 3: Verify all 5 files exist and are non-empty**

```bash
find /home/gawashi/dotfiles/.claude/rules/cpp -name "*.md" | wc -l
```

Expected: `5`

```bash
find /home/gawashi/dotfiles/.claude/rules/cpp -name "*.md" -empty
```

Expected: no output.

- [ ] **Step 4: Verify cpp/ files have C++-specific paths in frontmatter**

```bash
grep "\.cpp\|\.hpp\|\.cc" /home/gawashi/dotfiles/.claude/rules/cpp/coding-style.md | head -3
```

Expected: at least one line showing `.cpp`, `.hpp`, or `.cc` path pattern.

- [ ] **Step 5: Verify cpp/testing.md references a test framework**

```bash
wc -l /home/gawashi/dotfiles/.claude/rules/cpp/testing.md
```

Expected: non-zero (file has content). Then:

```bash
grep -c "." /home/gawashi/dotfiles/.claude/rules/cpp/testing.md
```

Expected: number > 10 (file has substantial content, not just a stub).

- [ ] **Step 6: Remove .gitkeep now that rules/ has real content**

```bash
rm /home/gawashi/dotfiles/.claude/rules/.gitkeep
```

- [ ] **Step 7: Confirm git sees the new files correctly**

```bash
cd /home/gawashi/dotfiles
git status --short | grep "rules/"
```

Expected: 14 new `.md` files listed under `.claude/rules/common/` and `.claude/rules/cpp/`, and the `.gitkeep` deletion.

- [ ] **Step 8: Commit the rule files**

```bash
cd /home/gawashi/dotfiles
git add .claude/rules/
git commit -m "feat: add C++ and common rules from everything-claude-code"
```

---

### Task 3: Unit-test the new install_claude_rules logic in isolation before editing install.sh

Before changing `install.sh`, verify the new `find`-based loop logic works correctly in a temp directory. This catches path-stripping bugs early.

- [ ] **Step 1: Run isolated unit test in a temp directory**

```bash
TMPDIR_TEST=$(mktemp -d)
TMPDIR_SRC="$TMPDIR_TEST/src/rules"
TMPDIR_DST="$TMPDIR_TEST/dst/rules"

mkdir -p "$TMPDIR_SRC/common" "$TMPDIR_SRC/cpp" "$TMPDIR_DST"
echo "# common test" > "$TMPDIR_SRC/common/testing.md"
echo "# cpp test"    > "$TMPDIR_SRC/cpp/coding-style.md"

# Run the new logic inline
while IFS= read -r -d '' file; do
    rel_path="${file#"$TMPDIR_SRC"/}"
    abs_source="$(realpath "$file")"
    target="$TMPDIR_DST/$rel_path"
    target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"
    ln -sf "$abs_source" "$target"
done < <(find "$TMPDIR_SRC" -name "*.md" -print0)

# Verify symlinks
echo "=== Symlinks created ==="
find "$TMPDIR_DST" -name "*.md" -exec ls -la {} \;

# Verify rel_path stripping is correct (should be 'common/testing.md', not full path)
readlink "$TMPDIR_DST/common/testing.md"
readlink "$TMPDIR_DST/cpp/coding-style.md"

rm -rf "$TMPDIR_TEST"
```

Expected:
- `readlink` output for each file shows the absolute path inside `$TMPDIR_SRC`, not a mangled path
- Both `common/testing.md` and `cpp/coding-style.md` symlinks exist under `$TMPDIR_DST`
- No errors

---

### Task 4: Update install_claude_rules to recursive find-based symlinking

**Files:**
- Modify: `install.sh` — replace `install_claude_rules` function body

The current implementation only handles flat `*.md` files in the rules root. We replace the `for` glob loop with a `find`-based loop.

- [ ] **Step 1: Confirm the current function text to match (prevents wrong-location edit)**

```bash
grep -n "install_claude_rules" /home/gawashi/dotfiles/install.sh
```

Expected: output shows the function definition line (e.g., `190:install_claude_rules() {`).

- [ ] **Step 2: Replace the install_claude_rules function body in install.sh**

Locate the function by name and replace the entire block `install_claude_rules() { ... }` with:

```bash
install_claude_rules() {
    local rules_source="$BASEDIR/.claude/rules"
    local rules_target="$HOME/.claude/rules"

    if [[ ! -d "$rules_source" ]]; then
        return 0
    fi

    while IFS= read -r -d '' file; do
        [[ -f "$file" ]] || continue
        local rel_path="${file#"$rules_source"/}"
        local abs_source
        abs_source="$(realpath "$file" 2>/dev/null || echo "$file")"
        local target="$rules_target/$rel_path"
        local target_dir
        target_dir="$(dirname "$target")"
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$target_dir"
        fi
        install_claude_symlink "$abs_source" "$target" ".claude/rules/$rel_path"
    done < <(find "$rules_source" -name "*.md" -print0)
}
```

- [ ] **Step 3: Verify the function was replaced (not duplicated)**

```bash
grep -c "install_claude_rules" /home/gawashi/dotfiles/install.sh
```

Expected: `2` (one definition, one call site).

- [ ] **Step 4: Verify dry-run logs all 14 rule files**

```bash
cd /home/gawashi/dotfiles
bash install.sh -d -y 2>&1 | grep "Would link" | grep "rules" | wc -l
```

Expected: `14`

```bash
bash install.sh -d -y 2>&1 | grep "Would link" | grep "rules"
```

Expected: 14 lines like `[INFO] Would link .claude/rules/common/agents.md -> /home/gawashi/dotfiles/.claude/rules/common/agents.md`

---

### Task 5: Update install_claude_skills to recursive find-based symlinking

**Files:**
- Modify: `install.sh` — replace `install_claude_skills` function body

Note: `install_claude_skills` appears **before** `install_claude_rules` in the file. Match by function name.

- [ ] **Step 1: Confirm the current function text to match**

```bash
grep -n "install_claude_skills" /home/gawashi/dotfiles/install.sh
```

Expected: output shows definition line and call site.

- [ ] **Step 2: Replace the install_claude_skills function body in install.sh**

Locate the function by name and replace the entire block `install_claude_skills() { ... }` with:

```bash
install_claude_skills() {
    local skills_source="$BASEDIR/.claude/skills"
    local skills_target="$HOME/.claude/skills"

    if [[ ! -d "$skills_source" ]]; then
        return 0
    fi

    while IFS= read -r -d '' file; do
        [[ -f "$file" ]] || continue
        local rel_path="${file#"$skills_source"/}"
        local abs_source
        abs_source="$(realpath "$file" 2>/dev/null || echo "$file")"
        local target="$skills_target/$rel_path"
        local target_dir
        target_dir="$(dirname "$target")"
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$target_dir"
        fi
        install_claude_symlink "$abs_source" "$target" ".claude/skills/$rel_path"
    done < <(find "$skills_source" -name "*.md" -print0)
}
```

- [ ] **Step 3: Verify the function was replaced (not duplicated)**

```bash
grep -c "install_claude_skills" /home/gawashi/dotfiles/install.sh
```

Expected: `2` (one definition, one call site).

- [ ] **Step 4: Verify dry-run runs cleanly (no parse errors or unexpected output)**

```bash
cd /home/gawashi/dotfiles
bash -n install.sh && echo "Syntax OK"
```

Expected: `Syntax OK`

```bash
bash install.sh -d -y 2>&1 | grep -iE "error|syntax|unbound" || echo "No errors"
```

Expected: `No errors`

---

### Task 6: End-to-end verification

- [ ] **Step 1: Run install and verify symlinks are created correctly**

```bash
cd /home/gawashi/dotfiles
mkdir -p "$HOME/.claude/rules" "$HOME/.claude/skills"
bash install.sh -y 2>&1 | grep -E "Linked|already correctly linked" | grep "rules"
```

Expected: 14 lines (one per rule file).

- [ ] **Step 2: Verify target directories are real directories, not symlinks**

```bash
file ~/.claude/rules/common
file ~/.claude/rules/cpp
```

Expected: both show `directory` (not `symbolic link`).

- [ ] **Step 3: Verify individual file symlinks point to dotfiles**

```bash
readlink ~/.claude/rules/cpp/testing.md
readlink ~/.claude/rules/common/coding-style.md
```

Expected:
```
/home/gawashi/dotfiles/.claude/rules/cpp/testing.md
/home/gawashi/dotfiles/.claude/rules/common/coding-style.md
```

- [ ] **Step 4: Verify plugin-added files in ~/.claude/rules/ are NOT tracked by dotfiles git**

```bash
# Simulate a plugin adding a file directly to the real directory (not inside dotfiles)
touch ~/.claude/rules/plugin-added.md
touch ~/.claude/rules/common/plugin-added.md

# Confirm neither file appears in dotfiles git status
cd /home/gawashi/dotfiles
git status --short | grep "plugin-added" && echo "FAIL: tracked" || echo "PASS: not tracked"
```

Expected: `PASS: not tracked`

```bash
rm ~/.claude/rules/plugin-added.md ~/.claude/rules/common/plugin-added.md
```

---

### Task 7: Commit install.sh changes

**Files:**
- Modify: `install.sh`

- [ ] **Step 1: Review the diff — only the two function bodies should have changed**

```bash
cd /home/gawashi/dotfiles
git diff install.sh | grep "^[-+]" | grep -v "^---\|^+++" | head -40
```

Expected: changes confined to `install_claude_skills` and `install_claude_rules` function bodies. No other functions modified.

- [ ] **Step 2: Commit**

```bash
cd /home/gawashi/dotfiles
git add install.sh
git commit -m "feat: support recursive subdirectory symlinking for rules and skills"
```
