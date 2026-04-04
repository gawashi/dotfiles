# Brainstorm Skill Robustness Improvements — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add three robustness features (anti-pattern warning, strict one-question rule, reviewer companion file) and tighten wording throughout the brainstorm skill.

**Architecture:** Surgical edits to one existing file plus one new companion file. No structural changes to the skill's step ordering.

**Tech Stack:** Markdown skill files

---

## File Structure

| File | Action | Responsibility |
|---|---|---|
| `.claude/skills/brainstorm/SKILL.md` | Modify | Skill definition — add anti-pattern, strengthen rules, compact wording |
| `.claude/skills/brainstorm/reviewer-prompt.md` | Create | Subagent reviewer instructions for Step 7 |

---

### Task 1: Compact the description block

**Files:**
- Modify: `.claude/skills/brainstorm/SKILL.md:2-10`

- [ ] **Step 1: Replace the description field**

Replace lines 2-10 (the entire `description` field in frontmatter) with:

```markdown
description: >
  General-purpose brainstorming for non-software topics. Trigger when the user presents an
  open-ended idea, decision, creative project, business idea, research direction, or life
  planning question — even without explicitly asking. Do NOT trigger for software development
  topics — defer to superpowers:brainstorming instead.
```

- [ ] **Step 2: Verify the frontmatter is valid**

Read the file and confirm the YAML frontmatter parses correctly (opening `---`, fields, closing `---`).

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/brainstorm/SKILL.md
git commit -m "refactor(brainstorm): compact description block"
```

---

### Task 2: Add anti-pattern warning

**Files:**
- Modify: `.claude/skills/brainstorm/SKILL.md`

- [ ] **Step 1: Insert anti-pattern section after the deferral rule**

After the `## Deferral rule` section (after "Then stop.") and before `## Process`, insert:

```markdown
## Anti-Pattern: "This Is Just A Quick Question"

Every topic goes through this process. A career fork, a naming decision, a one-paragraph
plan — all of them. "Quick" topics are where unexamined assumptions cause the most wasted
thinking. The document can be short, but you MUST complete the process and get approval.
```

- [ ] **Step 2: Verify placement**

Read the file and confirm the anti-pattern section sits between `## Deferral rule` and `## Process`.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/brainstorm/SKILL.md
git commit -m "feat(brainstorm): add anti-pattern warning for trivializing topics"
```

---

### Task 3: Strengthen the one-question rule

**Files:**
- Modify: `.claude/skills/brainstorm/SKILL.md`

- [ ] **Step 1: Replace Step 2 opening and remove trailing line**

Replace the current Step 2 content (from "Ask one question at a time..." through "Don't front-load all questions at once. Let answers inform the next question.") with:

```markdown
**One question per message. No exceptions.** If two questions feel related, they are still
two messages. Use multiple-choice format where possible — it's faster for the user and
surfaces options they might not have considered. Focus on:

- **Purpose** — what outcome are they hoping for?
- **Constraints** — time, money, people, energy, hard limits
- **Who it's for** — just themselves, a team, an audience, a customer?
- **Success criteria** — what does "done" or "good" look like?
```

The trailing line "Don't front-load all questions at once. Let answers inform the next question." is removed — it's now redundant with the strict rule.

- [ ] **Step 2: Verify the edit**

Read the file and confirm Step 2 starts with the bold one-question rule and has no trailing "Don't front-load" line.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/brainstorm/SKILL.md
git commit -m "feat(brainstorm): enforce strict one-question-per-message rule"
```

---

### Task 4: Compact Steps 5, 6, 8, and 9

**Files:**
- Modify: `.claude/skills/brainstorm/SKILL.md`

- [ ] **Step 1: Compact Step 5 — remove redundant second sentence**

Replace the Step 5 body:

```markdown
Present the planned document structure and get agreement on it. Then co-create the content
through dialogue, section by section — present each section as a draft or outline, get the
user's approval or feedback, then refine before moving on. This is collaborative dialogue:
you're building agreement on the content, not writing the final file yet.
```

With:

```markdown
Present the planned document structure and get agreement on it. Then co-create the content
through dialogue, section by section — present each section as a draft or outline, get the
user's approval or feedback, then refine before moving on.
```

- [ ] **Step 2: Compact Step 6 — trim slug explanation**

Replace:

```markdown
Use today's date. The topic slug is a short kebab-case summary of the topic (e.g.,
`career-pivot-decision`, `podcast-launch-plan`).
```

With:

```markdown
Use today's date. Topic slug examples: `career-pivot-decision`, `podcast-launch-plan`.
```

- [ ] **Step 3: Compact Step 8 — remove self-reference**

Replace:

```markdown
Wait for the user's response. If they request changes, update the document and re-run the
review loop (Step 8) before returning here.
```

With:

```markdown
Wait for the user's response. If they request changes, update the document and re-run the
review loop before returning here.
```

- [ ] **Step 4: Compact Step 9 — remove trailing line**

Remove the last line of Step 9:

```markdown
Present them as numbered choices. The user can also suggest something not on the list.
```

Replace with:

```markdown
Present them as numbered choices.
```

- [ ] **Step 5: Verify all four compacting edits**

Read the file and confirm all four changes are applied correctly.

- [ ] **Step 6: Commit**

```bash
git add .claude/skills/brainstorm/SKILL.md
git commit -m "refactor(brainstorm): compact wording in steps 5, 6, 8, 9"
```

---

### Task 5: Create the reviewer companion file

**Files:**
- Create: `.claude/skills/brainstorm/reviewer-prompt.md`

- [ ] **Step 1: Write the reviewer prompt file**

Create `.claude/skills/brainstorm/reviewer-prompt.md`. The file has two sections: a header explaining when to use it, then a fenced code block containing the subagent dispatch template.

**File header (plain markdown):**

```markdown
# Brainstorm Document Reviewer Prompt

Use this when dispatching a subagent to review a brainstorming document.

**Dispatch after:** Document is written to `docs/brainstorming/`.
```

**Then a fenced code block** (triple backticks) containing the dispatch template:

```yaml
Agent tool (general-purpose):
  description: "Review brainstorm document"
  prompt: |
    You are a brainstorming document reviewer. Verify this document is complete
    and ready for the user to act on.

    **Document to review:** [DOC_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Completeness | TODOs, placeholders, "TBD", incomplete sections |
    | Consistency | Internal contradictions, conflicting statements |
    | Clarity | Ideas or requirements ambiguous enough to cause wrong action |
    | Scope | Focused on a single topic — not multiple independent ideas bundled together |
    | YAGNI | Unnecessary padding or over-engineering |

    ## Calibration

    **Only flag issues that would block the user from acting on this document.**
    A missing section, a contradiction, or a recommendation so vague it could mean
    two different things — those are issues. Minor wording preferences, stylistic
    choices, and "some sections shorter than others" are not.

    Approve unless there are serious gaps.

    ## Output Format

    ## Document Review

    **Status:** PASS | Issues Found

    **Issues (if any):**
    - [Section]: [specific issue] — [why it matters]

    **Recommendations (advisory, do not block approval):**
    - [suggestions for improvement]
```

- [ ] **Step 2: Verify the file exists and reads correctly**

Read the file and confirm the formatting is correct.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/brainstorm/reviewer-prompt.md
git commit -m "feat(brainstorm): add reviewer companion file for subagent dispatch"
```

---

### Task 6: Update Step 7 to reference the companion file

**Files:**
- Modify: `.claude/skills/brainstorm/SKILL.md`

- [ ] **Step 1: Replace Step 7 body**

Replace the entire Step 7 body (from "After writing the document, dispatch a subagent..." through "...surface them to the user rather than silently moving on.") with:

```markdown
After writing the document, dispatch a subagent to review it using the instructions in
`brainstorm/reviewer-prompt.md`. Maximum 3 iterations. If unresolved issues remain after
3 iterations, surface them to the user.
```

- [ ] **Step 2: Verify the edit**

Read the file and confirm Step 7 references the companion file and the inline bullet list is gone.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/brainstorm/SKILL.md
git commit -m "refactor(brainstorm): reference reviewer companion file in step 7"
```

---

### Task 7: Final verification

**Files:**
- Read: `.claude/skills/brainstorm/SKILL.md`
- Read: `.claude/skills/brainstorm/reviewer-prompt.md`

- [ ] **Step 1: Read the full skill file and verify all changes**

Confirm:
- Description block is compacted (roughly 5 lines in the `description` field)
- Anti-pattern section exists between Deferral rule and Process
- Step 2 starts with bold one-question rule, no trailing "Don't front-load" line
- Step 5 has no "This is collaborative dialogue" sentence
- Step 6 has compact slug explanation
- Step 7 references `brainstorm/reviewer-prompt.md`, no inline bullet list
- Step 8 has no "(Step 8)" self-reference
- Step 9 has no "The user can also suggest" trailing line

- [ ] **Step 2: Read the reviewer prompt and verify**

Confirm the file has the dispatch template with all 5 check categories and the output format.

- [ ] **Step 3: Count lines**

The skill file should be shorter than the original 145 lines.
