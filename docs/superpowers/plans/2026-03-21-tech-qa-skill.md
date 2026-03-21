# tech-qa Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a `/tech-qa` skill that answers technical questions by researching authoritative sources (context7, WebSearch, WebFetch) and explaining concepts at appropriate depth based on question complexity.

**Architecture:** A single SKILL.md file at `.claude/skills/tech-qa/SKILL.md` containing the full skill instructions. The skill classifies questions into Simple/Medium/Deep complexity, executes a research flow with cross-verification requirements scaled to complexity, and formats the answer using a complexity-matched template. The skill-creator workflow is used for testing and iteration.

**Note:** The spec references `superpowers:brainstorming` as the deferral target for feature/architecture questions. The actual installed skill is named `brainstorm` (no "ing"). The SKILL.md uses `/superpowers:brainstorm` to match the real skill name.

**Tech Stack:** Markdown (skill file), JSON (evals), Python (skill-creator eval scripts), Claude subagents (test runners)

---

## File Structure

| Action | Path | Purpose |
|--------|------|---------|
| Create | `.claude/skills/tech-qa/SKILL.md` | The skill itself |
| Create | `tech-qa-workspace/evals/evals.json` | Test cases for skill-creator loop |
| Create | `tech-qa-workspace/iteration-1/` | First test run outputs |

---

### Task 1: Create the Skill Directory

**Files:**
- Create: `.claude/skills/tech-qa/` (directory)

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p /home/gawashi/dotfiles/.claude/skills/tech-qa
```

- [ ] **Step 2: Verify directory was created**

```bash
ls /home/gawashi/dotfiles/.claude/skills/
```

Expected: `tech-qa/` appears alongside `brainstorm/` and `create-github-issue/`.

---

### Task 2: Write SKILL.md

**Files:**
- Create: `.claude/skills/tech-qa/SKILL.md`

The skill must include:
- YAML frontmatter with `name` and `description` (description is the primary trigger mechanism — make it aggressive about matching technical questions asked in isolation)
- Deferral rules: debugging → `superpowers:systematic-debugging`, feature/architecture decisions → `superpowers:brainstorming`
- Boundary rule: understanding a concept by itself = tech-qa; deciding how to use it in a codebase = brainstorming
- Complexity classification table (Simple / Medium / Deep) with "when in doubt, classify one level up"
- Research flow: context7 first → WebSearch fallback → WebFetch for specific pages
- Cross-verification requirements by level (Simple: 1 source, Medium: 2, Deep: 3 with 2 primary)
- Synthesis rule: distill, don't quote verbatim
- Output format templates for each complexity level:
  - Simple: 1–3 paragraphs, no headers, direct answer, sources at end
  - Medium: Summary → Explanation → Code example (when valuable) → Sources (markdown links with title)
  - Deep: Overview → How It Works → Key Concepts → Example (when valuable) → Gotchas → Sources (markdown links with title)
- Cross-level rules: lead with answer, always cite sources as markdown links with title

- [ ] **Step 1: Write SKILL.md**

Create `.claude/skills/tech-qa/SKILL.md` with the full content below:

```markdown
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
```

- [ ] **Step 2: Verify the file loads without error**

```bash
head -20 /home/gawashi/dotfiles/.claude/skills/tech-qa/SKILL.md
```

Expected: YAML frontmatter visible with `name: tech-qa`.

- [ ] **Step 3: Commit the skill**

```bash
git add .claude/skills/tech-qa/SKILL.md
git commit -m "feat: add tech-qa skill for researching technical questions"
```

---

### Task 3: Write Test Cases

**Files:**
- Create: `tech-qa-workspace/evals/evals.json`

Come up with 3 test cases — one per complexity level (Simple, Medium, Deep). These should be realistic questions a developer would ask.

- [ ] **Step 1: Create workspace and evals directory**

```bash
mkdir -p /home/gawashi/dotfiles/tech-qa-workspace/evals
```

- [ ] **Step 2: Write evals.json**

Create `tech-qa-workspace/evals/evals.json`:

```json
{
  "skill_name": "tech-qa",
  "evals": [
    {
      "id": 0,
      "prompt": "What does the nullish coalescing operator do in JavaScript?",
      "expected_output": "A concise 1-3 paragraph answer explaining that ?? returns the right-hand operand when the left is null or undefined (but not other falsy values like 0 or empty string). No headers. Sources cited at end.",
      "files": []
    },
    {
      "id": 1,
      "prompt": "How do I use Python's asyncio for concurrent HTTP requests?",
      "expected_output": "A structured answer with Summary, Explanation, and Example sections. Covers asyncio.gather or TaskGroup for concurrent awaiting, aiohttp or httpx for async HTTP. At least 2 sources cited.",
      "files": []
    },
    {
      "id": 2,
      "prompt": "How does the Raft consensus algorithm work and what are its tradeoffs compared to Paxos?",
      "expected_output": "A deep-format answer with Overview, How It Works, Key Concepts, Gotchas, and Sources. Covers leader election, log replication, safety guarantees. Compares with Paxos on understandability, performance, and implementation complexity. At least 3 sources, 2 primary.",
      "files": []
    }
  ]
}
```

- [ ] **Step 3: Present test cases to user for approval**

Show the 3 test cases and confirm they look right before proceeding.

---

### Task 4: Run Test Cases (With-Skill and Baseline in Parallel)

**Files:**
- Create: `tech-qa-workspace/iteration-1/` directory structure

For each test case, spawn TWO subagents in the same turn — one with the skill, one without.

- [ ] **Step 1: Create iteration-1 directory**

```bash
mkdir -p /home/gawashi/dotfiles/tech-qa-workspace/iteration-1
```

- [ ] **Step 2: Spawn all 6 subagents in one turn using the Agent tool**

Launch all 6 Agent tool calls in a single message (3 with-skill + 3 without-skill). Each Agent call should use `run_in_background: true`. The prompts for each:

**Eval 0 — with-skill:**
```
You are testing a Claude Code skill. Read the skill at /home/gawashi/dotfiles/.claude/skills/tech-qa/SKILL.md, then follow it to answer this question:

"What does the nullish coalescing operator do in JavaScript?"

Save your full response (the answer you would show the user) to:
/home/gawashi/dotfiles/tech-qa-workspace/iteration-1/eval-0-nullish-coalescing/with_skill/outputs/response.md
```

**Eval 0 — without-skill (baseline):**
```
Answer this question as you normally would, with no special instructions:

"What does the nullish coalescing operator do in JavaScript?"

Save your full response to:
/home/gawashi/dotfiles/tech-qa-workspace/iteration-1/eval-0-nullish-coalescing/without_skill/outputs/response.md
```

**Eval 1 — with-skill:**
```
You are testing a Claude Code skill. Read the skill at /home/gawashi/dotfiles/.claude/skills/tech-qa/SKILL.md, then follow it to answer this question:

"How do I use Python's asyncio for concurrent HTTP requests?"

Save your full response to:
/home/gawashi/dotfiles/tech-qa-workspace/iteration-1/eval-1-asyncio-http/with_skill/outputs/response.md
```

**Eval 1 — without-skill (baseline):**
```
Answer this question as you normally would, with no special instructions:

"How do I use Python's asyncio for concurrent HTTP requests?"

Save your full response to:
/home/gawashi/dotfiles/tech-qa-workspace/iteration-1/eval-1-asyncio-http/without_skill/outputs/response.md
```

**Eval 2 — with-skill:**
```
You are testing a Claude Code skill. Read the skill at /home/gawashi/dotfiles/.claude/skills/tech-qa/SKILL.md, then follow it to answer this question:

"How does the Raft consensus algorithm work and what are its tradeoffs compared to Paxos?"

Save your full response to:
/home/gawashi/dotfiles/tech-qa-workspace/iteration-1/eval-2-raft-vs-paxos/with_skill/outputs/response.md
```

**Eval 2 — without-skill (baseline):**
```
Answer this question as you normally would, with no special instructions:

"How does the Raft consensus algorithm work and what are its tradeoffs compared to Paxos?"

Save your full response to:
/home/gawashi/dotfiles/tech-qa-workspace/iteration-1/eval-2-raft-vs-paxos/without_skill/outputs/response.md
```

- [ ] **Step 3: Write eval_metadata.json for each eval directory**

```json
{
  "eval_id": 0,
  "eval_name": "nullish-coalescing",
  "prompt": "What does the nullish coalescing operator do in JavaScript?",
  "assertions": []
}
```

- [ ] **Step 4: Capture timing data as subagents complete**

When each subagent task notification arrives, extract the actual token count and duration from the Agent tool result (look for `total_tokens` and `duration_ms` in the result metadata). Write `timing.json` to the run directory with real values:

```json
{
  "total_tokens": <actual value from agent result>,
  "duration_ms": <actual value from agent result>,
  "total_duration_seconds": <duration_ms / 1000>
}
```

---

### Task 5: Draft Assertions While Tests Run

**Files:**
- Modify: `tech-qa-workspace/evals/evals.json` (add assertions)
- Modify: `tech-qa-workspace/iteration-1/eval-*/eval_metadata.json` (add assertions)

While test subagents are running, draft quantitative assertions for each eval.

- [ ] **Step 1: Draft assertions for each eval**

Assertions to check:

- `leads_with_answer`: Response opens with the direct answer, not preamble or "Great question!"
- `sources_cited`: Response ends with at least one source as a Markdown link with title
- `no_fabricated_urls`: All cited URLs are real (fetched during research, not invented)
- `correct_format_simple` (eval 0 only): No headers, 1-3 paragraphs
- `correct_format_medium` (eval 1 only): Has Summary and Explanation sections
- `correct_format_deep` (eval 2 only): Has Overview, How It Works, Key Concepts, Gotchas, and Sources sections
- `min_sources_met`: Simple ≥ 1, Medium ≥ 2, Deep ≥ 3

- [ ] **Step 2: Update evals.json and eval_metadata.json with assertions**

Add the assertions array to each eval in both files.

- [ ] **Step 3: Explain assertions to user**

Describe what each assertion checks and why it matters.

---

### Task 6: Grade Runs and Launch Eval Viewer

**Files:**
- Create: `tech-qa-workspace/iteration-1/eval-*/grading.json`
- Create: `tech-qa-workspace/iteration-1/benchmark.json`
- Create: `tech-qa-workspace/iteration-1/benchmark.md`

- [ ] **Step 1: Resolve the skill-creator directory**

```bash
SKILL_CREATOR_DIR=$(ls -d /home/gawashi/.claude/plugins/cache/claude-plugins-official/skill-creator/*/skills/skill-creator | head -1)
echo "Skill-creator directory: $SKILL_CREATOR_DIR"
```

If no match is found, abort and ask the user to verify the skill-creator plugin is installed.

- [ ] **Step 2: Grade each run**

Read `$SKILL_CREATOR_DIR/agents/grader.md` for grading instructions, then evaluate each assertion against the outputs. Save `grading.json` to each run directory.

```json
{
  "expectations": [
    {
      "text": "Response leads with the direct answer, not preamble",
      "passed": true,
      "evidence": "First sentence is: 'The nullish coalescing operator (??) returns...'"
    }
  ]
}
```

- [ ] **Step 3: Aggregate into benchmark**

```bash
cd "$SKILL_CREATOR_DIR" && python -m scripts.aggregate_benchmark \
  /home/gawashi/dotfiles/tech-qa-workspace/iteration-1 \
  --skill-name tech-qa
```

- [ ] **Step 4: Launch eval viewer**

```bash
cd "$SKILL_CREATOR_DIR" && nohup python eval-viewer/generate_review.py \
  /home/gawashi/dotfiles/tech-qa-workspace/iteration-1 \
  --skill-name "tech-qa" \
  --benchmark /home/gawashi/dotfiles/tech-qa-workspace/iteration-1/benchmark.json \
  > /dev/null 2>&1 &
VIEWER_PID=$!
echo "Viewer PID: $VIEWER_PID"
```

If no display available, use `--static /tmp/tech-qa-review-1.html` instead.

- [ ] **Step 5: Tell user to review**

> "Results are open in your browser. 'Outputs' tab lets you click through each test case and leave feedback; 'Benchmark' shows pass rates and timing. When you're done, come back and let me know."

---

### Task 7: Read Feedback and Iterate

- [ ] **Step 1: When user signals done, read feedback.json**

```bash
cat /home/gawashi/dotfiles/tech-qa-workspace/iteration-1/feedback.json
```

- [ ] **Step 2: Kill the viewer**

```bash
kill $VIEWER_PID 2>/dev/null
```

- [ ] **Step 3: Update SKILL.md based on feedback**

Focus on test cases where the user left specific complaints. Generalize from specific feedback — avoid overfitting to the exact test cases.

- [ ] **Step 4: If iteration needed, re-run Tasks 4-7 into iteration-2/**

If the user is satisfied, proceed to Task 8.

---

### Task 8: Final Commit

- [ ] **Step 1: Stage and commit the updated skill**

```bash
git add .claude/skills/tech-qa/SKILL.md
git commit -m "feat: finalize tech-qa skill after eval iteration"
```

- [ ] **Step 2: Verify commit**

```bash
git log --oneline -3
```
