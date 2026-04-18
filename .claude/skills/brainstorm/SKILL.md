---
name: brainstorm
description: >
  General-purpose brainstorming for non-software topics. Trigger when the user presents an
  open-ended idea, decision, creative project, business idea, research direction, or life
  planning question — even without explicitly asking. Also trigger when the user is weighing
  options, exploring a concept, facing a personal dilemma, or needs to think through something
  without a clear next action. Do NOT trigger for software development topics — defer to
  superpowers:brainstorming instead.
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

## Anti-Pattern: "This Is Just A Quick Question"

Every topic goes through this process. A career fork, a naming decision, a one-paragraph
plan — all of them. "Quick" topics are where unexamined assumptions cause the most wasted
thinking. The document can be short, but you MUST complete the process and get approval.

## Process

Follow these steps in order.

### Step 1: Explore context

Before asking questions, understand what the user already knows and has tried. Acknowledge the
topic and summarize your understanding of it. If the user came with background information,
reflect it back briefly so they can confirm or correct it.

### Step 2: Scope check

Before going deep, check whether the topic is actually multiple independent sub-problems bundled
together. If it is, flag it:

> "It looks like this covers a few separate questions: [list them]. It'll be easier to think
> clearly if we tackle them one at a time. Which should we start with?"

Help the user decompose and pick a starting point before continuing.

### Step 3: Ask clarifying questions

**One question per message. No exceptions.** If two questions feel related, they are still
two messages. Use multiple-choice format where possible — it's faster for the user and
surfaces options they might not have considered. Focus on:

- **Purpose** — what outcome are they hoping for?
- **Constraints** — time, money, people, energy, hard limits
- **Who it's for** — just themselves, a team, an audience, a customer?
- **Success criteria** — what does "done" or "good" look like?

### Step 4: Propose approaches

Offer 2-3 distinct ways to approach the topic. For each, give:
- A short label or name
- What it entails
- Key trade-offs (pros and cons)

End with a recommendation and your reasoning. Ask the user which direction they want to take.

### Step 5: Write the document

Once the user approves the chosen approach in Step 4, write the full document to disk at:

```
docs/brainstorming/YYYY-MM-DD-<topic-slug>.md
```

Use today's date. Topic slug examples: `career-pivot-decision`, `podcast-launch-plan`.

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

### Step 6: Self-review

After writing the document, review it yourself against the checklist in `reviewer-prompt.md`
in this skill's directory (next to this SKILL.md). Read your own output critically —
Completeness, Consistency, Clarity, Scope, YAGNI — and revise in place until the checklist
passes. Do not dispatch a subagent.

### Step 7: User review gate

After self-review passes, send:

> "Doc written to `<path>`. Please review it and let me know if you want any changes before
> we look at next steps."

Wait for the user's response. If they request changes, update the document and re-run
Step 6 before returning here.

### Step 8: Offer next steps

After the user approves the document, pick 2-3 options from this pool — choose the ones most
relevant to the specific topic and what the user is trying to accomplish:

- **Create an action plan** — break the idea into concrete steps with owners and sequencing
- **Turn into a pitch/outline** — structure for presenting to others
- **Identify risks and open questions** — dedicated deep-dive on what could go wrong
- **Research further** — identify key things to investigate before committing
- **Nothing** — always include this; the user can take the doc and go

Present them as numbered choices.
