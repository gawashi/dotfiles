# tech-qa Skill Design

## Overview

A Claude Code skill that answers technical questions by researching authoritative sources and explaining concepts at appropriate depth. Combines always-on live research (web search, official docs, source cross-verification) with an adaptive explanation format matched to question complexity.

## Trigger & Identity

- **Skill name:** `tech-qa`
- **Slash command:** `/tech-qa`
- **Auto-triggers when:** the user asks how something works, what a concept means, or how to use a library/tool/API **in isolation** (understanding the technology itself, not applying it to a specific codebase or feature)
- **Does NOT trigger for:**
  - Debugging broken code → defer to `superpowers:systematic-debugging`
  - Feature planning, architecture decisions, or questions about how to apply a technology within a specific project → defer to `superpowers:brainstorming`
  - General conversation or non-technical topics

**Boundary rule:** if the question is about understanding a concept or API by itself, it belongs here. If the question requires deciding how to use it within a specific codebase or feature, defer to `superpowers:brainstorming`.

## Complexity Classification

Before researching, classify the question into one of three levels. This drives both research depth and output format. When in doubt, classify one level up.

| Level | Criteria |
|---|---|
| **Simple** | Quick definition, yes/no, single-concept lookup (e.g., "what does `Array.flat` do?") |
| **Medium** | Explaining how something works or how to use it (e.g., "how do I use React context?") |
| **Deep** | Architecture, comparisons, tradeoffs, or multi-concept investigation (e.g., "how does Kubernetes scheduling work?") |

## Research Flow

Execute these steps in order after classifying complexity:

1. **Search in priority order:**
   - `context7` first for library, framework, or API questions (official, versioned documentation); if context7 returns no results, fall through to WebSearch
   - `WebSearch` for concepts, architecture topics, recent releases, or anything context7 doesn't cover
   - `WebFetch` to pull specific pages when a source looks authoritative
2. **Cross-verify by complexity level:**
   - Deep: at least 3 sources, with at least 2 being primary sources (official docs, specs, or authoritative references)
   - Medium: at least 2 sources
   - Simple: a single authoritative source is sufficient
3. **Synthesize** — distill findings into a coherent answer; do not quote raw documentation verbatim

## Adaptive Output Format

Format is determined by the complexity level classified above:

**Simple** — 1–3 paragraphs, no headers, direct answer first, sources at end

**Medium** — structured sections:
- Summary
- Explanation
- Code example (only when it meaningfully clarifies; omit if it adds no value)
- Sources — Markdown links with title, e.g. `[React Docs – Context](https://react.dev/learn/passing-data-deeply-with-context)`

**Deep** — structured sections:
- Overview
- How It Works
- Key Concepts
- Example (only when it meaningfully clarifies; omit if it adds no value)
- Gotchas — common mistakes, known limitations, or version-specific behaviors to watch out for
- Sources — Markdown links with title

Rules across all levels:
- Lead with the answer, context comes after (no preamble)
- Always cite sources at the end as Markdown links with title
