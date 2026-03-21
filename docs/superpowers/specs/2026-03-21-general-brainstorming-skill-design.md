# General-Purpose Brainstorming Skill Design

**Date:** 2026-03-21
**Status:** Draft

## Problem

The existing `superpowers:brainstorming` skill is tightly coupled to software development — it ends by invoking `writing-plans`, saves documents to `docs/superpowers/specs/`, and frames everything around architecture, components, and code. There is no skill for brainstorming non-software topics: personal decisions, creative projects, business ideas, research directions, and so on.

## Goal

A general-purpose brainstorming skill (`/brainstorm`) that helps users think through any kind of topic via structured collaborative dialogue, and always produces a written document capturing the outcome. After the document is reviewed, Claude offers 2-3 relevant next steps based on the topic type.

## Skill Name and Location

- **Name:** `brainstorm`
- **File:** `.claude/skills/brainstorm/SKILL.md`
- **Invocation:** `/brainstorm` or `/brainstorm <topic>`

## Trigger Conditions

**Explicit (user-initiated):**
- User types `/brainstorm` or `/brainstorm <topic>`
- User says "let's brainstorm", "help me think through", "I have an idea I want to explore"

**Proactive (Claude-initiated):**
- User presents an open-ended idea, decision, or creative concept without a clear next action
- User is weighing options and hasn't reached a conclusion

**Deferral rule:** If the topic is software development (new feature, architecture decision, codebase change), Claude defers to the existing `superpowers:brainstorming` skill instead.

## Process Flow

```
1. Explore context
2. Offer visual companion (own message, no other content)
3. Ask clarifying questions (one at a time, multiple choice preferred)
4. Scope check — decompose if too large
5. Propose 2-3 approaches with trade-offs and recommendation
6. Present design in sections, get approval after each
7. Write document → docs/brainstorming/YYYY-MM-DD-<topic-slug>.md
8. Review loop (subagent, max 3 iterations)
9. User review gate
10. Offer 2-3 next steps appropriate to the topic
```

## Clarifying Questions

Focus on: purpose, constraints, who it's for, success criteria, what "done" looks like. One question per message, multiple choice preferred. Before going deep, check scope — if the topic is actually multiple independent sub-problems, flag it and help decompose first.

## Document Format

Document sections are chosen dynamically based on topic type. Examples:

| Topic Type | Sections |
|---|---|
| Decision | Problem/Situation → Options → Pros & Cons → Risks → Recommendation → Open Questions |
| Creative | Concept → Audience & Purpose → Format/Medium → Key Elements → Open Questions |
| Business/Product | Problem → Hypothesis → Target Audience → Approach → Risks & Assumptions → Validation Steps |
| Research/Learning | Topic → Goal → Key Questions → Resources → Approach |
| Other | Claude infers appropriate sections from the conversation |

All documents always end with an **Open Questions** or **Next Steps** section.

All documents include frontmatter:

```markdown
---
topic: <topic name>
date: YYYY-MM-DD
type: <decision | creative | business | research | other>
---
```

Documents are saved to: `docs/brainstorming/YYYY-MM-DD-<topic-slug>.md`

## Document Review Loop

After writing the document, dispatch a subagent to verify it is complete and useful. The reviewer checks:

- No TODOs, placeholders, or incomplete sections
- No internal contradictions
- Requirements/ideas clear enough to act on
- Scoped to a single topic (not multiple independent ideas bundled together)
- No unnecessary padding or over-engineering

Re-dispatch if issues are found. Maximum 3 iterations; surface to the user if not resolved by then.

## User Review Gate

After the review loop passes:

> "Doc written and committed to `<path>`. Please review it and let me know if you want any changes before we look at next steps."

Wait for user response. If changes are requested, update the doc and re-run the review loop.

## Next Steps Offering

After user approves the doc, Claude picks 2-3 options from this pool — choosing the most relevant for the specific topic:

- **Create an action plan** — break the idea into concrete steps with owners and sequencing
- **Turn into a pitch/outline** — structure for presenting to others
- **Identify risks and open questions** — dedicated deep-dive on what could go wrong
- **Research further** — identify key things to investigate before committing
- **Write implementation plan** — if software-adjacent, invoke `writing-plans` skill
- **Nothing** — always included; user can take the doc and go

Options are presented as numbered choices. The user can also suggest something not on the list.

## Visual Companion

Same as the existing brainstorming skill. Offer once when visual questions are anticipated:

> "Some of what we're working on might be easier to explain if I can show it to you in a web browser. I can put together mockups, diagrams, comparisons, and other visuals as we go. This feature is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"

This offer is its own message — not combined with questions or other content. If accepted, read the visual companion guide from the `superpowers:brainstorming` skill directory (this is a shared dependency — the path resolves via the superpowers plugin cache) before proceeding. Decide per-question whether visuals add value.

## Out of Scope

- Replacing `superpowers:brainstorming` for software development topics
- Typed document templates per domain (can be added in v2 if patterns emerge)
- Automatic next-step execution (user always chooses)
