# create-github-issue Skill Design

**Date:** 2026-03-21
**Status:** Approved

## Problem

During implementation, design deficiencies, contradictions, and oversights are discovered. These need to be captured without interrupting ongoing development work, and tracked for later resolution.

## Goal

A general-purpose development skill (`/create-github-issue`) that Claude or the user can invoke at any point during implementation to register a GitHub Issue. Always shows a preview before registering. After confirmation, creates the Issue and immediately resumes implementation.

## Skill Name

`create-github-issue`

**Location:** User-authored general development skill (not superpowers-specific)

## Trigger Conditions

- **Claude initiates:** When Claude detects a design issue, contradiction, or oversight during implementation, it proposes invoking this skill
- **User initiates:** User types `/create-github-issue`

## Behavior Flow

```
Invoked
  ↓
1. Auto-detect current repository via `gh repo view`
2. Fetch existing labels via `gh label list`
3. Collect current work context
   - Active file(s) and task name
   - Phase/Plan reference from docs/superpowers/plans/ or .planning/
4. Compose Issue content
   - Title: verb-first (e.g. "Fix undefined redirect behavior in auth flow")
   - Body: using template below
   - Labels: selected from existing labels — no new labels created
5. Display preview — ALWAYS
   → User approves  → execute `gh issue create`
   → User edits     → revise content, show preview again
   → User cancels   → abort, resume implementation
6. Report: "Issue #N created: <URL>" (single line)
7. Resume implementation
```

## Issue Title Convention

Verb-first, specific and descriptive:

- `Fix undefined redirect behavior after OAuth login`
- `Resolve contradiction between plan and schema in user model`
- `Handle missing error case in file sync logic`

## Issue Body Template

```markdown
## Problem
<Description of the design deficiency, contradiction, or oversight>

## Context
- **File/Symbol:** <File or function where the issue was discovered>
- **Task:** <Name of the task currently being worked on>
- **Phase/Plan:** <Retrieved from docs/superpowers/plans/ or .planning/>

## Workaround Applied
<Temporary fix applied, if any — omit this section if none>
```

## Label Selection

Claude selects from existing labels retrieved via `gh label list`. No new labels are created. Claude picks the most contextually appropriate label(s) from the existing set.

## Repository Detection

Auto-detected from the current git remote via `gh repo view`. No manual specification needed.

## gh CLI Usage

```bash
body=$(cat <<'EOF'
## Problem
...

## Context
- **File/Symbol:** src/auth/redirect.ts
- **Task:** Implement OAuth callback handler
- **Phase/Plan:** Phase 3 — docs/superpowers/plans/2026-03-21-auth.md

## Workaround Applied
Added null check as temporary guard.
EOF
)

gh issue create \
  --title "Fix undefined redirect behavior after OAuth login" \
  --body "$body" \
  --label "bug"
```

## Out of Scope

- Creating new GitHub labels
- Proposing a fix (deferred to when the issue is resolved)
- Batch issue creation at end of phase
- Integration into other skills (this skill is standalone)
- `--dry-run` flag (preview is always shown, so no need)
