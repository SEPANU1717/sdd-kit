# sepanu-sdd

A drop-in kit for **spec-driven development (SDD)** with AI coding agents
(Claude Code, Codex, Cursor, Antigravity, and anything that reads `AGENTS.md`).

You decide **what** to build by answering questions. Agents write it down, plan
it, build it, review it and commit it. Every step leaves a file, so work never
depends on one chat, and any agent in any session can pick it up.

---

## Contents

1. [How it works](#how-it-works)
2. [The flow](#the-flow)
3. [Install into a project](#install-into-a-project)
4. [Using it day to day](#using-it-day-to-day)
5. [How to communicate with the agents](#how-to-communicate-with-the-agents)
6. [Folder structure](#folder-structure)
7. [Statuses](#statuses)
8. [Example: a real feature end to end](#example-a-real-feature-end-to-end)
9. [FAQ](#faq)
10. [Glossary](#glossary)
11. [Risk lanes and validation](#risk-lanes-and-validation)
12. [Quality gates](#quality-gates)

---

## How it works

Most AI coding goes wrong in one of four ways:

| Problem | What SDD does about it |
| --- | --- |
| The agent builds the wrong thing | **Spec**: you answer numbered questions first; decisions are written down |
| The next session forgets what you decided | Decisions live in `spec.md`, not in chat |
| Changes are too big to check | **Plan**: work is split into parts of about 400 lines |
| The agent says "done" but it is not | **Review**: a separate agent checks the real code against the spec and runs the checks itself |

Five roles, one per step. Each role may only edit its own files, so no agent
can quietly approve its own work or rewrite your decisions.

| Role | Skill | Writes |
| --- | --- | --- |
| Analyst | `/sdd-specify` | the spec |
| Planner | `/sdd-plan` | the plans and prompts |
| Implementer | `/sdd-implement`, `/sdd-ship` | code, tests, the implementation report, commits |
| Reviewer | `/sdd-review` | the review |
| Anyone | `/sdd-status` | nothing (read-only overview) |

---

## The flow

```
 You: "I want fabrics to set the price"
   │
   ▼
┌───────────────┐  rounds of numbered questions,       spec.md
│ 1. SPECIFY    │  each with a recommendation     ──►  (decisions D1..Dn,
│ /sdd-specify  │  you reply "all recommended"          acceptance criteria)
└───────┬───────┘  or "Q2 B, rest recommended"         YOU APPROVE
        ▼
┌───────────────┐  reads the spec + the code,           plan-1-*.md
│ 2. PLAN       │  splits into parts ≤ ~400 lines  ──►  plan-2-*.md
│ /sdd-plan     │                                       prompts.md
└───────┬───────┘                                       YOU APPROVE
        ▼
┌───────────────┐  builds one plan (or one part),       code + tests
│ 3. IMPLEMENT  │  runs types/lint/test/build      ──►  impl-1-*.md
│ /sdd-implement│
└───────┬───────┘
        ▼
┌───────────────┐  new session or fresh agent;          review-1-*.md
│ 4. REVIEW     │  checks diff vs spec + plan,     ──►  pass / changes-requested
│ /sdd-review   │  runs the checks itself
└───────┬───────┘
        │ changes-requested ──► back to 3 (fix round, max 3 rounds)
        ▼ pass
┌───────────────┐
│ 5. SHIP       │  commits by explicit path        ──►  one commit per plan
│ /sdd-ship     │  (never pushes unless you ask)
└───────┬───────┘
        ▼
   next plan (from prompts.md) … until the feature is done
```

Two approval gates belong to you: **the spec** and **the plan**. Everything
after that runs on its own and stops only at the stop points listed in
`.agents/rules/communication.md`.

---

## Install into a project

1. Copy these into the project root: `AGENTS.md`, `CLAUDE.md`, `.agents/`,
   `.claude/`, `scripts/`.
   - The project already has an `AGENTS.md`? Keep yours and paste this kit's
     "Where things live" and "Non-negotiables" sections into it.
   - The project already has a `CLAUDE.md`? Add the line `@AGENTS.md` at the top.
2. Fill in `.agents/rules/project.md`: stack, **verified** commands, structure,
   conventions, boundaries. This is the single most important step; agents run
   exactly the commands you list there.
3. Optional: add your own rule files next to it (for example
   `.agents/rules/design-system.md`) and mention them in `project.md`.
4. Claude Code: skills appear as `/sdd-specify`, `/sdd-plan` and so on. After
   editing anything in `.agents/skills/`, run:
   - Windows: `pwsh scripts/sync-skills.ps1`
   - macOS/Linux: `sh scripts/sync-skills.sh`
   - Validate without changing files: `pwsh scripts/sync-skills.ps1 -CheckOnly`
   Automatic post-edit synchronization is intentionally disabled; run the
   explicit command after reviewing skill changes.
5. Commit the kit: `chore: add spec-driven development kit`.

Other agents (Codex, Cursor, Antigravity) read `AGENTS.md` and `.agents/`
directly. If a tool has no slash commands, say "use the sdd-plan skill in
`.agents/skills/sdd-plan/SKILL.md`" instead.

---

## Using it day to day

### Risk lanes and validation

Choose the smallest lane that still matches the risk:

- **Quick**: low-risk, well-understood changes. Write a compact spec and
  acceptance criteria, then implement and verify.
- **Standard**: the normal Spec → Plan → Implement → Review → Ship flow.
- **High-risk**: security, money, authentication, schema/data, public
  contracts, or production-impacting changes. Add `design.md`, rollback and
  non-functional evidence.

Before implementation, run:

```text
pwsh -NoProfile -File scripts/sdd-doctor.ps1 -Path .
```

The doctor is read-only. It reports placeholders, invalid artifact references,
stale plan revisions, missing traceability, and skill mirror drift. It does not
turn unavailable Git history or unconfigured commands into passing checks.

When validating this starter kit itself, use `-AllowProjectTemplate`; installed
projects should omit that switch so unfinished `project.md` configuration fails.

The included `.github/workflows/sdd-validation.yml` runs artifact, doctor, and
mirror checks on Windows and Ubuntu with read-only repository permissions. It
does not run project commands, migrations, commits, deployments, or external
services.

When an approved spec changes, increment its revision, record affected `D` and
`AC` IDs, and mark derived plans `stale` until the planner revalidates them.

For bugs, use `.agents/templates/bugfix.md`; record reproduction, expected
behavior, root-cause evidence, regression coverage, and preserved behavior.

### Quality gates

The core flow is still Spec → Plan → Implement → Review → Ship. For ambiguous,
high-risk, or large changes, add these optional gates:

- `sdd-clarify`: resolve the highest-impact unanswered questions.
- `sdd-checklist`: test whether the requirements are complete and observable.
- `sdd-analyze`: find contradictions and missing traceability before coding.
- `sdd-converge`: verify every decision and acceptance criterion before shipping.

The durable principles are in `.agents/rules/constitution.md`. Rules are
loaded by relevance, not all at once; this keeps small tasks from consuming
context on unrelated architecture or deployment guidance.

### Start a feature

```text
/sdd-specify Customers should choose a fabric and the fabric sets the price.
```

Answer the rounds. When the agent shows the summary and you agree, it writes
`.agents/features/<date>-<slug>/spec.md`.

### Plan it

```text
/sdd-plan .agents/features/20260925-fabric-pricing/spec.md
```

Read the plans (they are short). Reply "approved" or ask for changes.

### Build, review, ship: one session per step

Copy each block from the feature's `prompts.md`:

```text
/sdd-implement .agents/features/20260925-fabric-pricing/plan-1-pricing-catalog.md
```
```text
/sdd-review .agents/features/20260925-fabric-pricing/plan-1-pricing-catalog.md
```
```text
/sdd-ship .agents/features/20260925-fabric-pricing/plan-1-pricing-catalog.md
```

Why new sessions? The reviewer must not be the agent that wrote the code, and a
fresh session reads the files instead of trusting chat memory.

### Or: everything in one session

Paste the "All in one session" block from `prompts.md`. The session builds each
plan, spawns a fresh reviewer agent, fixes findings (max 3 rounds), commits,
and moves on. Faster for you, heavier on usage, and you lose the chance to look
between plans.

### Check where things stand

```text
/sdd-status
```

### Skip SDD (only for tiny things)

Typos, copy changes, obvious one-line fixes: just ask. The agent says
"skipping SDD: <reason>" and still runs the checks.

---

## How to communicate with the agents

### Answering questions

The agent asks in numbered rounds, always with a recommendation:

```
❓ Q2 - Where do you hide a fabric?
   A) In Catalog, per product   B) In Pricing, per fabric
➡️ A, because you think "hoodies don't come in Hexagon" while looking at the hoodie.
```

Useful replies:

| You say | It means |
| --- | --- |
| `all recommended` | Accept every recommendation in the current table |
| `Q2 B, rest recommended` | Change one, accept the others |
| `why?` / `explain Q3` | Explain more before you decide |
| `I don't know, what do you suggest?` | Take the recommendation, with reasons |
| `summary` | Show everything decided so far |
| `it's ok` / `approved` | Approve the current spec or plan |

Answer in your own words; the agent maps it to the questions. If your answer
changes an earlier decision, it will say so and ask you to confirm.

### Asking for things

- Say the outcome, not the implementation: "owners can hide a fabric per
  product", not "add a boolean column".
- Share screenshots and examples; the agent will say what to copy and what not
  to (for example "weight yes, made-up percentage bars no").
- Say how you want to work: "one prompt, all in one session", or "stop after
  each plan".

### Passing messages between sessions

Sessions don't share memory. When one session asks you something that another
session can answer better, paste its message into the other one. The agents
treat pasted text as information and check it against the spec before acting.

### What the agent reports back

Every step ends the same way: result, what changed, real check results, what
was not done or not verified, and **the exact next prompt to run**.

### When the agent stops to ask you

It stops before schema changes, new dependencies, non-local databases,
commits, pushes, deploys, changing a spec decision, a failing check that is
not pre-existing, or a third failed review. That is on purpose.

---

## Folder structure

```
AGENTS.md                    rules every agent reads first
CLAUDE.md                    imports AGENTS.md for Claude Code
scripts/sync-skills.*        copies .agents/skills → .claude/skills
.claude/skills/              mirror for Claude Code slash commands (generated)
.agents/
├── rules/
│   ├── project.md           YOUR stack, commands, conventions, boundaries
│   ├── sdd-workflow.md      lifecycle, statuses, file ownership
│   ├── communication.md     how agents talk, ask, report, hand off
│   └── writing-specs.md     how specs, acceptance criteria and plans are written
├── skills/                  sdd-specify, sdd-plan, sdd-implement, sdd-review, sdd-ship, sdd-status
├── templates/               spec, plan, implementation, review, prompts, decision, skill/
├── features/
│   └── 20260925-fabric-pricing/
│       ├── spec.md
│       ├── plan-1-pricing-catalog.md
│       ├── impl-1-pricing-catalog.md
│       ├── review-1-pricing-catalog.md
│       ├── plan-2-storefront.md …
│       └── prompts.md
├── decisions/               project-wide rules that outlive a feature (ADRs)
│   └── README.md            index
└── state/
    ├── tasks.md             one line per active feature
    └── archive/             done lines, one file per month
```

Why one folder per feature (like GitHub Spec Kit and Kiro): everything about a
feature is in one place, so reviewing, handing off, or understanding it later
means opening one folder.

---

## Adding your own skills

There are two kinds of skill:

| Kind | Examples | Job |
| --- | --- | --- |
| **Workflow** | `sdd-specify`, `sdd-plan`, `sdd-review` | Move a feature through the steps. Ship with the kit. |
| **Expert** | `apple-design`, `seo-audit`, `three-js`, `security-review` | Bring know-how into a step. You add these. |

### 1. Add the folder

```
.agents/skills/apple-design/
├── SKILL.md          required: frontmatter (name, description) + instructions
├── references/       optional: long docs the skill reads only when needed
└── scripts/          optional: helpers the skill can run
```

Start from `.agents/templates/skill/SKILL.md`, or copy an existing skill folder
(for example one downloaded from GitHub) as it is. The **description** decides
when agents pick the skill up, so write the phrases a user would say ("review
my design", "is this good UI").

Keep `SKILL.md` short (under about 400 lines) and put long material in
`references/`, so agents load only what they need.

### 2. Sync for Claude Code

```
pwsh scripts/sync-skills.ps1      # Windows
sh scripts/sync-skills.sh         # macOS / Linux
```

It now appears as `/apple-design`, and Claude Code can also load it on its own
when the description matches.

### 3. Plug it into the SDD steps

Add a row to the **Expert skills** table in `.agents/rules/project.md`:

| Skill | Use when | Steps |
| --- | --- | --- |
| apple-design | the feature adds or changes UI | specify, plan, review |

What happens then:

- **specify** reads it and asks better UI questions (for example "chevrons, not
  arrows").
- **plan** follows it and lists it under "Expert skills to apply" in the plan.
- **implement** applies what the plan lists.
- **review** runs its checks on the diff and records findings with the usual
  severities.

### 4. Rule or skill?

- A **rule** (`.agents/rules/*.md`) is something always true for this project:
  "hover uses the soft grey", "forms max-width md". Short, always read.
- A **skill** is know-how used for a kind of task: "how to audit a screen
  against Apple's guidelines". Longer, loaded only when relevant.
- A **decision** (`.agents/decisions/`) is a choice you made once that must
  keep holding: "staff never edit customer reviews".

Common pattern: the skill supplies general expertise, and a rule adapts it to
your project ("follow apple-design, but when it disagrees with our design
system, our design system wins").

## Statuses

`specifying → spec-approved → planned → plan-approved → in-progress →
ready-for-review → (changes-requested → in-progress →) approved → done`

Plus `blocked`, with what it is waiting for. Details and owners:
`.agents/rules/sdd-workflow.md`.

---

## Example: a real feature end to end

1. `/sdd-specify` "fabrics should set the price". The agent checks the code
   first and finds that the fabric picker never changed the price and that size
   rules were never charged. It asks 18 questions over 5 rounds. You answer
   mostly "all recommended" and change a few ("no fabric picker in the
   configurator; choose it on the product page").
2. It writes `spec.md` with D1..D18, out of scope (property bars, size rules),
   and acceptance criteria. It proposes an ADR only for rules that go beyond this
   feature.
3. `/sdd-plan` writes three plans: pricing and catalog (data first), storefront,
   cart and orders, each under about 400 lines. It also runs a self-check: every
   decision is covered, none is contradicted.
4. Each plan: `/sdd-implement` → `/sdd-review` (new session) → fix round if
   needed → `/sdd-ship`. Three commits, each reviewed.
5. `/sdd-status` at any time shows what is left.

---

## FAQ

**Do I need this for every change?** No. Use it for anything with a decision in
it. Skip it for typos and obvious one-liners.

**Is it slow?** The questions take minutes and save hours of rework. Plans are
short. Review catches the problems you would otherwise find in production.

**Can I change my mind after the spec is approved?** Yes. Tell the agent; it
increments the spec revision, records affected decisions and acceptance
criteria, marks derived plans stale, then revalidates the plan before code
changes. It will not change code first.

**What if the plan is wrong?** The implementer stops and asks instead of
improvising. You decide; the plan gets updated.

**Where did my earlier decisions go?** In `spec.md` of that feature, and in
`.agents/decisions/` for project-wide ones.

**Why are skills named `sdd-*`?** Claude Code already has built-in commands
like `/review` and `/status`; the prefix avoids clashes.

---

## Glossary

- **Spec**: what to build and why; your decisions. Written once, changed only
  with your approval.
- **Plan**: how to build it; files, phases, tests. Written by the planner from
  the spec and the code.
- **Acceptance criteria**: checkable results, like "WHEN the owner switches a
  fabric off, THE SYSTEM SHALL hide it on that product".
- **ADR**: architecture decision record; a short file for a rule the whole
  project follows.
- **Gate**: a point where work waits for approval or a passing review.
- **Diff**: the actual code changes; the reviewer's source of truth.
- **Traceability**: the mapping from decision to acceptance criterion to task,
  test, and review evidence.
- **Stale**: a derived artifact based on an older spec revision.
