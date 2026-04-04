# Brainstorm Skill Robustness Improvements

**Date:** 2026-04-03
**Status:** Draft

## Problem

The `brainstorm` skill works but has three robustness gaps: no guard against trivializing topics, weak enforcement of the one-question-per-message rule, and no structured reviewer prompt for the subagent review step. The skill is also wordier than it needs to be.

## Goal

Surgical edits to the existing skill that add three robustness features and tighten wording throughout, without changing the skill's structure or step ordering.

## Changes

### 1. Anti-pattern warning

Add a new section after the description block, before Step 1:

```markdown
## Anti-Pattern: "This Is Just A Quick Question"

Every topic goes through this process. A career fork, a naming decision, a one-paragraph
plan — all of them. "Quick" topics are where unexamined assumptions cause the most wasted
thinking. The document can be short, but you MUST complete the process and get approval.
```

### 2. Strict one-question rule

Replace the opening of Step 2 with:

```markdown
**One question per message. No exceptions.** If two questions feel related, they are still
two messages. Use multiple-choice format where possible — it's faster for the user and
surfaces options they might not have considered.
```

Remove the now-redundant trailing line: "Don't front-load all questions at once. Let answers inform the next question."

### 3. Reviewer companion file

Create `brainstorm/reviewer-prompt.md` containing the review criteria and subagent instructions. Replace Step 7's inline bullet list and explanation with:

```markdown
After writing the document, dispatch a subagent to review it using the instructions in
`brainstorm/reviewer-prompt.md`. Maximum 3 iterations. If unresolved issues remain after
3 iterations, surface them to the user.
```

**Companion file contents** — the reviewer prompt should include:

- **Role:** You are reviewing a brainstorming document for completeness and clarity.
- **Checks:**
  - No TODOs, placeholders, or incomplete sections
  - No internal contradictions
  - Ideas and requirements are clear enough to act on
  - Scoped to a single topic (not multiple independent ideas bundled together)
  - No unnecessary padding or over-engineering
- **Output format:** List issues found with locations. If no issues, report "PASS".
- **Severity:** Flag issues that would block the user from acting on the document. Minor style issues are not blocking.

### 4. Compacting

Tighten wording throughout without changing structure:

| Location | Change |
|---|---|
| Description block | Trim from 5 lines to 3, keep trigger conditions |
| Step 2 trailing line | Remove "Don't front-load all questions at once. Let answers inform the next question." (redundant with one-question rule) |
| Step 5 second sentence | Remove "This is collaborative dialogue: you're building agreement on the content, not writing the final file yet." (restates first sentence) |
| Step 6 slug explanation | Replace explanation with just examples: `(e.g., career-pivot-decision, podcast-launch-plan)` |
| Step 8 self-reference | Remove "(Step 8)" from "re-run the review loop (Step 8)" |
| Step 9 trailing line | Remove "The user can also suggest something not on the list." (implied) |

## Files Changed

| File | Action |
|---|---|
| `.claude/skills/brainstorm/SKILL.md` | Edit — add anti-pattern, strengthen one-question rule, reference reviewer, compact wording |
| `.claude/skills/brainstorm/reviewer-prompt.md` | Create — structured reviewer instructions for subagent |

## Out of Scope

- Changing step ordering (scope check placement, etc.)
- Adding task tracking requirements
- Adding commit step
- Visual companion reconciliation with spec
- Changes to the existing design spec document
