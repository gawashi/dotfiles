---
name: create-github-issue
description: >
  Creates a GitHub Issue to capture a design deficiency, contradiction, or oversight discovered
  during development — without interrupting the current task. Use this skill whenever Claude
  notices a problem that needs tracking (missing spec coverage, conflicting requirements,
  edge cases not addressed), or when the user types /create-github-issue. The skill collects
  context automatically, shows a preview, lets the user edit or cancel, then creates the issue
  and resumes implementation. Invoke proactively whenever there's a problem worth tracking,
  even if the user didn't explicitly ask.
---

# create-github-issue

This skill captures a GitHub Issue for a design problem discovered during implementation. It
runs a quick guided flow — gather context, compose the issue, preview, confirm or edit, create,
resume. The whole interaction takes under a minute and doesn't break your flow.

## When to invoke

- **Claude-initiated:** You spotted something during implementation — a spec gap, a contradiction
  between plan and code, an unhandled edge case, a decision that needs revisiting. Propose
  creating an issue rather than silently papering over the problem.
- **User-initiated:** The user types `/create-github-issue` (or similar phrasing).

## Step 1: Pre-flight checks

Run these first. If either fails, abort immediately with the message shown — don't proceed.

```bash
# Check authentication
gh auth status
```
If this fails: output `gh is not authenticated. Run \`gh auth login\` first.` and stop.

```bash
# Detect current repository
gh repo view --json nameWithOwner -q .nameWithOwner
```
If this fails: output `Could not detect a GitHub repository. Ensure you are in a git repo with a GitHub remote.` and stop.

## Step 2: Gather labels and context

Run in parallel to save time:

```bash
# Existing labels (pick from these — never create new ones)
gh label list --json name -q '.[].name'

# Phase/plan reference (most recently modified .md in plans directories)
ls -t docs/superpowers/plans/*.md 2>/dev/null | head -1
ls -t .planning/*.md 2>/dev/null | head -1
```

**Phase/Plan detection logic:**
1. Check `docs/superpowers/plans/` — take the most recently modified `.md` file
2. If that directory is empty or absent, check `.planning/` — same rule
3. If timestamps are equal (e.g., same-second mtime), use reverse lexicographic order (the
   filename that sorts last wins — date-prefixed filenames naturally make the latest date win)
4. If neither directory has `.md` files, omit the Phase/Plan line from the issue body entirely

Use the relative path as-is in the issue body (e.g., `docs/superpowers/plans/2026-03-21-auth.md`).

## Step 3: Compose the issue

**Title** — verb-first, specific and descriptive. The title should describe the problem
clearly enough that someone reading just the title understands what needs fixing.

Good examples:
- `Fix undefined redirect behavior after OAuth login`
- `Resolve contradiction between plan and schema in user model`
- `Handle missing error case in file sync logic`

**Body** — use this template exactly. Omit the `## Workaround Applied` section entirely
(including the heading) if no workaround was applied. Don't leave it blank.

```markdown
## Problem
<Description of the design deficiency, contradiction, or oversight>

## Context
- **File/Symbol:** <File or function where the issue was discovered>
- **Task:** <Name of the task currently being worked on>
- **Phase/Plan:** <Path from plans directory — omit this line if no plans directory found>

## Workaround Applied
<Temporary fix applied, if any — OMIT THIS ENTIRE SECTION including heading if no workaround>
```

**Labels** — select from the existing labels fetched above. Pick the most contextually
appropriate ones. If nothing fits, create the issue with no labels (that's fine).

## Step 4: Show preview and confirm

Always show the preview. The user needs to see what will be created before it's sent.

Present it like this:

```
--- Issue Preview ---
Title:  Fix undefined redirect behavior after OAuth login
Labels: bug
Body:
## Problem
...

## Context
- **File/Symbol:** src/auth/redirect.ts
- **Task:** Implement OAuth callback handler
- **Phase/Plan:** docs/superpowers/plans/2026-03-21-auth.md
---
Approve, edit, or cancel? (approve/edit/cancel)
```

**If approved** → proceed to Step 5.

**If cancelled** → output `Issue creation cancelled. Resuming implementation.` and resume
where you left off.

**If edit** → ask: "Which field would you like to change? (title / body / labels)" Accept
their correction in free text, update the field, regenerate the preview, and return to this
step. The user can cancel at any point in the edit loop.

## Step 5: Create the issue

Use a heredoc to handle multi-line bodies cleanly:

```bash
body=$(cat <<'EOF'
## Problem
...

## Context
- **File/Symbol:** src/auth/redirect.ts
- **Task:** Implement OAuth callback handler
- **Phase/Plan:** docs/superpowers/plans/2026-03-21-auth.md

## Workaround Applied
Added null check as temporary guard.
EOF
)

gh issue create \
  --title "Fix undefined redirect behavior after OAuth login" \
  --body "$body" \
  --label "bug"
```

If `gh issue create` fails (network error, permission denied, etc.), surface the error
message and ask: "Retry or abort?"

## Step 6: Report and resume

Output a single line: `Issue #N created: <URL>`

Then immediately resume implementation where you left off. No extra commentary needed.
