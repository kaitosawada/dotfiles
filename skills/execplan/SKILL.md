---
name: execplan
description: When writing complex features, significant refactors, or when the user explicitly asks, use an interactive ExecPlan process to design and implement. Use this skill whenever the user mentions planning, designing a feature, or asks for a structured approach to implementation.
---

# ExecPlan — Interactive Planning Skill

This skill guides you through an interactive, question-driven planning process before writing any code. The goal is to collaboratively refine the spec with the user so that by the time a plan is written, it reflects shared understanding — not a surprise wall of text.

## Process Overview

The process has three phases. Do not skip phases or rush to produce a plan. The user's understanding and buy-in at each phase is more important than speed.

```
Phase 1: Spec Discovery (big questions → small questions)
Phase 2: Implementation Design (technical decisions)
Phase 3: Plan Output & Approval
```

---

## Phase 1: Spec Discovery

**Goal:** Establish what we're building and why, from the user's perspective.

### Step 1: Understand the intent

Read the user's request carefully. Before asking anything, do your own research — read relevant files, grep the codebase, understand the current state. Then summarize your understanding in 2-3 sentences and ask the user to confirm or correct.

### Step 2: Big-picture questions (choice-based)

Ask 2-4 high-level questions about scope and direction. Present them as numbered choices so the user can respond quickly (e.g., "1" or "A"). Examples of good big-picture questions:

- "How should we handle X?"
  - A) Approach one — brief description
  - B) Approach two — brief description
  - C) Something else (please describe)

- "Should this include Y?"
  - A) Yes, full support
  - B) Minimal / later
  - C) No

Ask all big-picture questions in a single message. Wait for the user's response before continuing.

### Step 3: Detail questions (targeted)

Based on the user's answers, think deeper and ask follow-up questions about edge cases, constraints, and specifics. These can be Yes/No, short choices, or open-ended — whatever fits. Again, batch related questions into a single message.

### Completion criteria

Move to Phase 2 when you can describe the full scope of what we're building without any "TBD" or "depends on" items. If you're unsure, ask one more round. Do not proceed with ambiguity — the user wants to nail things down here.

---

## Phase 2: Implementation Design

**Goal:** Decide how to build it, technically.

### Step 1: Propose an approach

Based on Phase 1, present a brief technical approach: which files to touch, what patterns to follow, key architectural decisions. Keep it concise — a few bullet points, not an essay.

### Step 2: Technical choice questions

Ask about any decisions that have meaningful tradeoffs. Same format as Phase 1 — choices when possible, open-ended when needed. Examples:

- "Where should this logic live?"
  - A) In the existing module X
  - B) New module alongside X
  - C) Separate package

- "This requires a migration. Should we:"
  - A) Handle it automatically
  - B) Provide a manual migration guide

### Completion criteria

Move to Phase 3 when both the user and you agree on the implementation approach with no open technical questions.

---

## Phase 3: Plan Output & Approval

**Goal:** Produce a clear, actionable plan and get the user's go-ahead.

### Plan format

Write a plan document with these sections. Keep it readable — prose over checklists, but use structure where it helps.

```markdown
# [Short title]

## What & Why
What we're building and the user-visible outcome. 2-3 sentences.

## Decisions Made
Key decisions from Phase 1 and 2, with brief rationale. Bullet list.

## Implementation Steps
Ordered list of concrete steps. For each step:
- What to do (files, functions, changes)
- How to verify it worked

## Validation
How to confirm everything works end-to-end.
```

Save the plan to `execplan/` directory in the project root with a descriptive filename (e.g., `execplan/add-auth-middleware.md`).

### Approval

After showing the plan, ask: "This is the plan. OK to proceed, or anything to adjust?"

- If the user approves → begin implementation, following the plan step by step
- If the user wants changes → adjust the plan (update the file too), then re-confirm

---

## During Implementation

- Follow the plan step by step. Do not ask "should I continue?" — just proceed to the next step.
- If you discover something unexpected that affects the plan, pause and tell the user. Update the plan file with a note about the change and why.
- Commit frequently at natural checkpoints.

## Guidelines

- **ユーザーへの質問には必ず `AskUserQuestion` ツールを使用すること。** Phase 1・Phase 2 での選択肢提示や確認はすべて `AskUserQuestion` ツール経由で行い、通常のテキスト出力で質問しない。これにより、ユーザーの回答が明確に構造化され、会話の流れが整理される。
- Never produce the full plan before completing Phase 1 and 2. The interactive questioning IS the value.
- Batch related questions into single messages — don't ask one question at a time, that's tedious.
- Use the user's language and framing, not jargon they haven't used.
- When the user's answer is ambiguous, reflect back your interpretation and confirm.
- The plan document should be something you can restart from if context is lost.
