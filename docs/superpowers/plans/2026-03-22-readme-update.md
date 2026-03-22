# README.md Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update README.md to reflect the current state of the dotfiles repository.

**Architecture:** Single file replacement. Content defined in design spec at `docs/superpowers/specs/2026-03-22-readme-update-design.md`.

**Tech Stack:** Markdown

---

### Task 1: Rewrite README.md

**Files:**
- Modify: `README.md`

**Spec reference:** `docs/superpowers/specs/2026-03-22-readme-update-design.md`

- [ ] **Step 1: Replace README.md content**

Write the full updated README with these sections in order:

1. **Header + What's Included** — opening paragraph mentioning Linux and Windows (WSL2/PowerShell), followed by bullet list of all files:
   - `.bashrc`, `.bash_aliases`, `.bash_profile`, `.vimrc`, `.tmux.conf`, `.gitignore`
   - `.claude/` (skills, rules, and local settings)
   - `Microsoft.PowerShell_profile.ps1`
   - `install.sh`, `install.ps1`

2. **Quick Install - Linux** — clone to `~/dotfiles`, run `./install.sh`

3. **Quick Install - Windows (PowerShell)** — clone to `$HOME\dotfiles`, run `.\install.ps1`

4. **Installation Options (Linux)** — flags `-h`, `-f`, `-y`, `-d`, `-b` with examples (match `install.sh --help` output)

5. **Claude Code** with subsections:
   - Skills: `brainstorm`, `create-github-issue`, `tech-qa` with one-line descriptions
   - Rules: `.claude/rules/` exists for project-specific rules (currently empty)
   - Plugins (via `claude plugin install`) with descriptions and GitHub links:
     - `superpowers` — [GitHub](https://github.com/obra/superpowers)
     - `context7` — [GitHub](https://github.com/upstash/context7)
     - `serena` — [GitHub](https://github.com/oraios/serena)
     - `skill-creator` — [GitHub](https://github.com/anthropics/claude-plugins-official)
   - GSD (via `npx get-shit-done-cc@latest`) — [GitHub](https://github.com/gsd-build/get-shit-done)

Clone URL: `https://github.com/gawashi/dotfiles.git`

Style: English, no emoji headings, no Manual Setup section.

- [ ] **Step 2: Review the rendered output**

Read the written file and verify all sections match the spec.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: update README to reflect current project state"
```
