---
name: brainstorm
description: >
  General-purpose brainstorming assistant for any non-software topic. Use this skill whenever
  the user presents an open-ended idea, decision to make, creative project, business idea,
  research direction, personal dilemma, or life planning question — even if they didn't explicitly
  ask for brainstorming. Trigger when: the user is weighing options and hasn't reached a
  conclusion, exploring a concept, or needs to think through something without a clear next
  action. Do NOT trigger for software development topics (new features, architecture decisions,
  codebase changes) — defer to superpowers:brainstorming instead.
---

# brainstorm

Structured collaborative brainstorming for any non-software topic. Always ends with a written
document and a concrete offer of next steps.

## Deferral rule

If the topic is software development — a new feature, architecture decision, codebase change,
or anything that will result in writing or modifying code — stop here and output:

> "This looks like a software development topic. Use `/superpowers:brainstorm` for that — it's
> designed for features, architecture, and implementation planning."

Then stop.

## Process

Follow these steps in order.

### Step 1: Explore context

Before asking questions, understand what the user already knows and has tried. Acknowledge the
topic and summarize your understanding of it. If the user came with background information,
reflect it back briefly so they can confirm or correct it.

### Step 2: Offer visual companion

Send this as its own message — no questions or other content combined with it:

> "Some of what we're working on might be easier to explain if I can show it to you in a web
> browser. I can put together mockups, diagrams, comparisons, and other visuals as we go. This
> feature is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"

If accepted, find and read the visual companion guide. It is at:
`/home/gawashi/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.5/skills/brainstorming/visual-companion.md`
(if this path fails, search for `visual-companion.md` in the superpowers skills directory)

Decide per-question whether visuals add value — don't use the browser for everything.

### Step 3: Ask clarifying questions

Ask one question at a time. Use multiple-choice format where possible — it's faster for the
user and surfaces options they might not have considered. Focus on:

- **Purpose** — what outcome are they hoping for?
- **Constraints** — time, money, people, energy, hard limits
- **Who it's for** — just themselves, a team, an audience, a customer?
- **Success criteria** — what does "done" or "good" look like?

Don't front-load all questions at once. Let answers inform the next question.

### Step 4: Scope check

Before going deep, check whether the topic is actually multiple independent sub-problems bundled
together. If it is, flag it:

> "It looks like this covers a few separate questions: [list them]. It'll be easier to think
> clearly if we tackle them one at a time. Which should we start with?"

Help the user decompose and pick a starting point before continuing.

### Step 5: Propose approaches

Offer 2-3 distinct ways to approach the topic. For each, give:
- A short label or name
- What it entails
- Key trade-offs (pros and cons)

End with a recommendation and your reasoning. Ask the user which direction they want to take.

### Step 6: Design in sections

Present the planned document structure and get agreement on it. Then co-create the content
through dialogue, section by section — present each section as a draft or outline, get the
user's approval or feedback, then refine before moving on. This is collaborative dialogue:
you're building agreement on the content, not writing the final file yet.

### Step 7: Write the document

Once the content for all sections is agreed upon, write the final document to disk at:

```
docs/brainstorming/YYYY-MM-DD-<topic-slug>.md
```

Use today's date. The topic slug is a short kebab-case summary of the topic (e.g.,
`career-pivot-decision`, `podcast-launch-plan`).

**Document frontmatter** — always include at the top:

```markdown
---
topic: <topic name>
date: YYYY-MM-DD
type: <decision | creative | business | research | other>
---
```

**Document sections by topic type:**

| Topic Type | Sections |
|---|---|
| Decision | Problem/Situation → Options → Pros & Cons → Risks → Recommendation → Open Questions |
| Creative | Concept → Audience & Purpose → Format/Medium → Key Elements → Open Questions |
| Business/Product | Problem → Hypothesis → Target Audience → Approach → Risks & Assumptions → Validation Steps |
| Research/Learning | Topic → Goal → Key Questions → Resources → Approach |
| Other | Infer appropriate sections from the conversation |

Every document ends with an **Open Questions** or **Next Steps** section.

### Step 8: Review loop

After writing the document, dispatch a subagent to review it. The reviewer checks:

- No TODOs, placeholders, or incomplete sections
- No internal contradictions
- Ideas and requirements are clear enough to act on
- Scoped to a single topic (not multiple independent ideas bundled together)
- No unnecessary padding or over-engineering

If issues are found, fix them and re-dispatch. Maximum 3 iterations. If the document still has
unresolved issues after 3 iterations, surface them to the user rather than silently moving on.

### Step 9: User review gate

After the review loop passes, send:

> "Doc written to `<path>`. Please review it and let me know if you want any changes before
> we look at next steps."

Wait for the user's response. If they request changes, update the document and re-run the
review loop (Step 8) before returning here.

### Step 10: Offer next steps

After the user approves the document, pick 2-3 options from this pool — choose the ones most
relevant to the specific topic and what the user is trying to accomplish:

- **Create an action plan** — break the idea into concrete steps with owners and sequencing
- **Turn into a pitch/outline** — structure for presenting to others
- **Identify risks and open questions** — dedicated deep-dive on what could go wrong
- **Research further** — identify key things to investigate before committing
- **Write implementation plan** — if software-adjacent, invoke the `writing-plans` skill
- **Nothing** — always include this; the user can take the doc and go

Present them as numbered choices. The user can also suggest something not on the list.
