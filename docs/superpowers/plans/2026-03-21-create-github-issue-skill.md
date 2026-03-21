# create-github-issue Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a general-purpose Claude Code skill at `dotfiles/.claude/skills/create-github-issue.md` that lets Claude or the user register a GitHub Issue during implementation without interrupting ongoing work.

**Architecture:** Single markdown skill file with YAML frontmatter. The skill-creator skill handles the full development loop (draft → eval → iterate → optimize description). Final artifact is committed to dotfiles.

**Tech Stack:** Markdown (Claude Code skill format), `gh` CLI, skill-creator

**Spec:** `docs/superpowers/specs/2026-03-21-create-github-issue-skill-design.md`

---

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `dotfiles/.claude/skills/create-github-issue.md` | Create (via skill-creator) | The skill prompt file with YAML frontmatter |
| `dotfiles/.claude/skills/create-github-issue-workspace/` | Create (via skill-creator) | Evals, iteration outputs, benchmark data |

---

## Task 1: Implement skill via skill-creator

- [ ] **Step 1: Invoke the skill-creator skill**

  Use the `Skill` tool to invoke `skill-creator:skill-creator`.

  Provide the following context to skill-creator:

  > We have an approved spec for a new skill called `create-github-issue`. The skill file should be created at `dotfiles/.claude/skills/create-github-issue.md`. The workspace for evals should go in `dotfiles/.claude/skills/create-github-issue-workspace/`.
  >
  > **Spec:** `docs/superpowers/specs/2026-03-21-create-github-issue-skill-design.md`
  >
  > Please read the spec, then run the full skill-creator loop: draft the skill, write test cases, run evals (with-skill and baseline in parallel), show the eval viewer, iterate on feedback, and optimize the trigger description.

- [ ] **Step 2: Confirm skill file is written**

  After skill-creator completes, verify:
  ```bash
  ls dotfiles/.claude/skills/create-github-issue.md
  ```

  If the file is not present (e.g., skill-creator exited mid-loop), re-invoke skill-creator and resume from where it left off.

- [ ] **Step 3: Commit**

  ```bash
  git add dotfiles/.claude/skills/
  git commit -m "feat: add create-github-issue skill"
  ```
