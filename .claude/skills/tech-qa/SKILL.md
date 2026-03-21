---
name: tech-qa
description: >
  Answers technical questions by researching authoritative sources and explaining concepts at
  appropriate depth. Use this skill whenever the user asks how something works, what a concept
  means, or how to use a library/tool/API in isolation — understanding the technology itself,
  not applying it to a specific codebase or feature. Trigger on: "what is X", "how does X work",
  "what does X do", "explain X", "how do I use X", API lookups, concept definitions, technology
  comparisons, or architecture explanations. Do NOT trigger for: debugging broken code (defer to
  superpowers:systematic-debugging), feature planning or architecture decisions within a specific
  project (defer to superpowers:brainstorm), or general non-technical conversation.
---

# tech-qa

Answers technical questions with live research from authoritative sources. Always leads with
the answer, always cites sources.

## Deferral rules

Check these first. If the question matches a deferral case, stop and output the redirect message.

**Debugging broken code:**
> "This looks like a debugging problem. Use `/superpowers:systematic-debugging` for that —
> it's designed for diagnosing and fixing bugs."

**Feature planning, architecture decisions, or applying a technology within a project:**
> "This looks like it needs design thinking about how to apply this in your project. Use
> `/superpowers:brainstorm` for that — it's designed for features, architecture, and
> implementation planning."

**Boundary rule:** if the question is about understanding a concept or API by itself, it belongs
here. If the question requires deciding how to use it within a specific codebase or feature,
defer to brainstorming.

## Step 1: Classify complexity

Before researching, classify the question into one of three levels. This drives both research
depth and output format. When in doubt, classify one level up.

| Level | Criteria | Examples |
|---|---|---|
| **Simple** | Quick definition, yes/no, single-concept lookup | "What does `Array.flat` do?", "Is Python dynamically typed?" |
| **Medium** | Explaining how something works or how to use it | "How do I use React context?", "How does Go's garbage collector work?" |
| **Deep** | Architecture, comparisons, tradeoffs, multi-concept investigation | "How does Kubernetes scheduling work?", "Redis vs Memcached for session storage?" |

## Step 2: Research

Execute these steps in order:

1. **Search in priority order:**
   - `context7` first for library, framework, or API questions (official, versioned documentation). If context7 returns no results, fall through to WebSearch.
   - `WebSearch` for concepts, architecture topics, recent releases, or anything context7 doesn't cover.
   - `WebFetch` to pull specific pages when a source looks authoritative.

2. **Cross-verify by complexity level:**
   - **Simple:** a single authoritative source is sufficient
   - **Medium:** at least 2 sources
   - **Deep:** at least 3 sources, with at least 2 being primary sources (official docs, specs, or authoritative references)

3. **Synthesize** — distill findings into a coherent answer. Do not quote raw documentation verbatim.

## Step 3: Answer

Format is determined by the complexity level classified above.

### Simple format

1–3 paragraphs. No headers. Direct answer first, context after.

End with:

**Sources**
- [Title](url)

### Medium format

**Summary**
<1–2 sentence direct answer>

**Explanation**
<How it works or how to use it, structured clearly>

**Example**
<Code example — include ONLY when it meaningfully clarifies. Omit this section entirely if
it adds no value.>

**Sources**
- [Title](url)
- [Title](url)

### Deep format

**Overview**
<2–3 sentence high-level answer>

**How It Works**
<Mechanics, internals, or process explained>

**Key Concepts**
<Important terms, components, or ideas — use a list or sub-headers>

**Example**
<Code or configuration example — include ONLY when it meaningfully clarifies. Omit this
section entirely if it adds no value.>

**Gotchas**
<Common mistakes, known limitations, or version-specific behaviors to watch out for>

**Sources**
- [Title](url)
- [Title](url)
- [Title](url)

## Rules (all levels)

- Lead with the answer. No preamble, no "Great question!", no throat-clearing.
- Always cite sources at the end as Markdown links with descriptive title text.
- Never fabricate sources. If you can't find a source for a claim, say so.
