# Brainstorm Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a general-purpose `/brainstorm` skill that guides users through any non-software topic via structured dialogue and always produces a written document in `docs/brainstorming/`.

**Architecture:** A single SKILL.md file at `.claude/skills/brainstorm/SKILL.md` containing the full skill instructions. The skill-creator workflow is then used to test and iterate: test cases in `brainstorm-workspace/evals/evals.json`, results in `brainstorm-workspace/iteration-N/`. No additional supporting files are needed for the skill itself — the visual companion is reused from the existing superpowers:brainstorming skill.

**Tech Stack:** Markdown (skill file), JSON (evals), Python (skill-creator eval scripts), Claude subagents (test runners)

---

## File Structure

| Action | Path | Purpose |
|--------|------|---------|
| Create | `.claude/skills/brainstorm/SKILL.md` | The skill itself |
| Create | `brainstorm-workspace/evals/evals.json` | Test cases for skill-creator loop |
| Create | `brainstorm-workspace/iteration-1/` | First test run outputs |
| Create | `docs/brainstorming/` | Output directory for brainstorm documents |

---

### Task 1: Create the Skill Directory and Output Directory

**Files:**
- Create: `.claude/skills/brainstorm/` (directory)
- Create: `docs/brainstorming/` (directory)

- [ ] **Step 1: Create skill and output directories**

```bash
mkdir -p /home/gawashi/dotfiles/.claude/skills/brainstorm
mkdir -p /home/gawashi/dotfiles/docs/brainstorming
```

- [ ] **Step 2: Verify directories were created**

```bash
ls /home/gawashi/dotfiles/.claude/skills/
ls /home/gawashi/dotfiles/docs/
```

Expected: `brainstorm/` appears in both listings.

---

### Task 2: Write SKILL.md First Draft

**Files:**
- Create: `.claude/skills/brainstorm/SKILL.md`

The skill must include:
- YAML frontmatter with `name` and `description` (description is the primary trigger mechanism — make it "pushy" per skill-creator guidance)
- Deferral rule: software dev topics → use `superpowers:brainstorming` instead
- 10-step process (explore context → visual companion → questions → scope check → approaches → design sections → write doc → review loop → user gate → next steps)
- Document format table (Decision / Creative / Business / Research / Other)
- Document frontmatter spec (topic, date, type)
- Output path: `docs/brainstorming/YYYY-MM-DD-<topic-slug>.md`
- Review loop subagent prompt (inline)
- Next steps pool with 2-3 selection rule

- [ ] **Step 1: Write SKILL.md**

Create `.claude/skills/brainstorm/SKILL.md` with the full skill content based on the approved spec at `docs/superpowers/specs/2026-03-21-general-brainstorming-skill-design.md`.

- [ ] **Step 2: Verify the file loads without error**

```bash
head -20 /home/gawashi/dotfiles/.claude/skills/brainstorm/SKILL.md
```

Expected: YAML frontmatter visible with `name: brainstorm`.

---

### Task 3: Write Test Cases

**Files:**
- Create: `brainstorm-workspace/evals/evals.json`

Come up with 3 realistic test prompts — one per major topic type the skill targets. These should be the kind of thing a real user would say in a Claude Code session.

- [ ] **Step 1: Create workspace and evals directory**

```bash
mkdir -p /home/gawashi/dotfiles/brainstorm-workspace/evals
```

- [ ] **Step 2: Write evals.json**

Create `brainstorm-workspace/evals/evals.json`:

```json
{
  "skill_name": "brainstorm",
  "evals": [
    {
      "id": 0,
      "prompt": "I'm trying to decide whether to take a new job offer. It pays more but it's at a smaller company and I'd have to relocate. I'm not sure what to do.",
      "expected_output": "A structured decision document saved to docs/brainstorming/ covering the situation, options, pros/cons, risks, and a recommendation. The AI should ask clarifying questions before writing anything.",
      "files": []
    },
    {
      "id": 1,
      "prompt": "I want to start a YouTube channel about personal finance for people in their 20s. I have some ideas but I'm not sure how to make it stand out.",
      "expected_output": "A brainstorming document saved to docs/brainstorming/ covering concept, audience, format/medium, key differentiators, and open questions. Should propose 2-3 approaches before settling.",
      "files": []
    },
    {
      "id": 2,
      "prompt": "I need to plan a surprise birthday party for my partner. They like outdoor activities and good food. Budget is around $500.",
      "expected_output": "A planning document saved to docs/brainstorming/ with a clear concept, approach options, logistics, and next steps. Should clarify constraints before proposing ideas.",
      "files": []
    }
  ]
}
```

- [ ] **Step 3: Present test cases to user for approval**

Show the 3 test cases to the user and confirm they look right before proceeding.

---

### Task 4: Run Test Cases (With-Skill and Baseline in Parallel)

**Files:**
- Create: `brainstorm-workspace/iteration-1/` directory structure

For each test case, spawn TWO subagents in the same turn — one with the skill, one without. Do not batch sequentially.

- [ ] **Step 1: Create iteration-1 directory**

```bash
mkdir -p /home/gawashi/dotfiles/brainstorm-workspace/iteration-1
```

- [ ] **Step 2: Spawn all 6 subagents in one turn (3 with-skill + 3 without)**

For each eval (0, 1, 2), launch in the same message:

**With-skill run:**
```
Execute this task:
- Skill path: /home/gawashi/dotfiles/.claude/skills/brainstorm/SKILL.md
- Task: <eval prompt>
- Save outputs to: /home/gawashi/dotfiles/brainstorm-workspace/iteration-1/eval-<ID>-<name>/with_skill/outputs/
- Outputs to save: any .md files written to docs/brainstorming/, and a transcript summary
```

**Without-skill (baseline) run:**
```
Execute this task (no skill):
- Task: <eval prompt>
- Save outputs to: /home/gawashi/dotfiles/brainstorm-workspace/iteration-1/eval-<ID>-<name>/without_skill/outputs/
- Outputs to save: any .md files or free-form responses
```

Use these eval names for directory naming:
- eval-0: `career-decision`
- eval-1: `youtube-channel`
- eval-2: `birthday-party`

- [ ] **Step 3: Write eval_metadata.json for each eval directory**

```json
{
  "eval_id": 0,
  "eval_name": "career-decision",
  "prompt": "<the eval prompt>",
  "assertions": []
}
```

- [ ] **Step 4: Capture timing data as subagents complete**

When each subagent task notification arrives, immediately write `timing.json` to its run directory:

```json
{
  "total_tokens": 0,
  "duration_ms": 0,
  "total_duration_seconds": 0.0
}
```

---

### Task 5: Draft Assertions While Tests Run

**Files:**
- Modify: `brainstorm-workspace/evals/evals.json` (add assertions)
- Modify: `brainstorm-workspace/iteration-1/eval-*/eval_metadata.json` (add assertions)

While test subagents are running, draft quantitative assertions for each eval. Explain them to the user.

- [ ] **Step 1: Draft assertions for each eval**

Good assertions to check:
- `doc_written`: A `.md` file was saved to `docs/brainstorming/`
- `has_frontmatter`: The doc includes YAML frontmatter with `topic`, `date`, `type`
- `asked_questions_before_writing`: The transcript shows clarifying questions before the document was produced
- `proposed_approaches`: The transcript shows 2-3 approaches were offered
- `ends_with_open_questions_or_next_steps`: The document has a final "Open Questions" or "Next Steps" section
- `correct_output_path`: File path matches `docs/brainstorming/YYYY-MM-DD-*.md` pattern

- [ ] **Step 2: Update evals.json and eval_metadata.json with assertions**

Add the assertions array to each eval in both files.

- [ ] **Step 3: Explain assertions to user**

Describe what each assertion checks and why it matters.

---

### Task 6: Grade Runs and Launch Eval Viewer

**Files:**
- Create: `brainstorm-workspace/iteration-1/eval-*/grading.json`
- Create: `brainstorm-workspace/iteration-1/benchmark.json`
- Create: `brainstorm-workspace/iteration-1/benchmark.md`

- [ ] **Step 1: Grade each run**

Read `agents/grader.md` from the skill-creator directory, then evaluate each assertion against the outputs. Save `grading.json` to each run directory.

```json
{
  "expectations": [
    {
      "text": "A .md file was saved to docs/brainstorming/",
      "passed": true,
      "evidence": "File found at docs/brainstorming/2026-03-21-career-decision.md"
    }
  ]
}
```

For file-checkable assertions (doc_written, has_frontmatter, correct_output_path), write and run a script rather than eyeballing.

- [ ] **Step 2: Aggregate into benchmark**

```bash
python -m scripts.aggregate_benchmark \
  /home/gawashi/dotfiles/brainstorm-workspace/iteration-1 \
  --skill-name brainstorm
```

Run from the skill-creator directory:
```bash
cd /home/gawashi/.claude/plugins/cache/claude-plugins-official/skill-creator/61c0597779bd/skills/skill-creator
```

- [ ] **Step 3: Launch eval viewer**

```bash
nohup python eval-viewer/generate_review.py \
  /home/gawashi/dotfiles/brainstorm-workspace/iteration-1 \
  --skill-name "brainstorm" \
  --benchmark /home/gawashi/dotfiles/brainstorm-workspace/iteration-1/benchmark.json \
  > /dev/null 2>&1 &
VIEWER_PID=$!
echo "Viewer PID: $VIEWER_PID"
```

If no display available, use `--static /tmp/brainstorm-review-1.html` instead.

- [ ] **Step 4: Tell user to review**

> "Results are open in your browser. 'Outputs' tab lets you click through each test case and leave feedback; 'Benchmark' shows pass rates and timing. When you're done, come back and let me know."

---

### Task 7: Read Feedback and Iterate

- [ ] **Step 1: When user signals done, read feedback.json**

```bash
cat /home/gawashi/dotfiles/brainstorm-workspace/iteration-1/feedback.json
```

- [ ] **Step 2: Kill the viewer**

```bash
kill $VIEWER_PID 2>/dev/null
```

- [ ] **Step 3: Update SKILL.md based on feedback**

Focus on test cases where the user left specific complaints. Generalize from specific feedback — avoid overfitting to the exact test cases.

- [ ] **Step 4: If iteration needed, re-run Task 4-7 into iteration-2/**

If the user is satisfied, proceed to Task 8.

---

### Task 8: Commit

- [ ] **Step 1: Stage and commit the skill**

```bash
git add .claude/skills/brainstorm/SKILL.md docs/brainstorming/
git commit -m "feat: add general-purpose brainstorm skill"
```

- [ ] **Step 2: Verify commit**

```bash
git log --oneline -3
```
