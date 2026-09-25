# AGENTS.md

Read automatically by Claude Code (through `CLAUDE.md`), Codex, Cursor,
Antigravity and other agents that support `AGENTS.md`.

This repository uses **spec-driven development (SDD)**. Every non-trivial change
goes through: **Spec → Plan → Implement → Review → Ship**. Each step leaves a
file behind, so any agent in any session can continue without chat history.

Full guide for humans: `README.md`.

The durable project principles are in `.agents/rules/constitution.md`. Read the
constitution and only the rule files relevant to the current task; do not load
every project document by default.

Skill mirrors are synchronized explicitly with `scripts/sync-skills.*`. Do not
rely on editor hooks to mutate `.claude/skills/`; validate with the script's
`-CheckOnly` mode before committing.

## Instruction priority

1. The user's current request
2. The closest nested `AGENTS.md`
3. This file
4. `.agents/rules/` (project, workflow, communication, writing)
5. The active skill in `.agents/skills/`
6. The feature's own artifacts (spec, then plan)

Never silently ignore a higher-priority instruction. If two conflict, say so
before continuing.

## Where things live

| Path | What it holds |
| --- | --- |
| `.agents/rules/project.md` | Stack, commands, architecture, conventions (fill this in first) |
| `.agents/rules/sdd-workflow.md` | Lifecycle, statuses, gates, who owns which file |
| `.agents/rules/communication.md` | How agents talk to the user and to each other |
| `.agents/rules/writing-specs.md` | How to write specs, acceptance criteria and plans |
| `.agents/skills/` | Workflow skills (`sdd-*`) and expert skills; `INDEX.md` lists them all (generated) |
| `.agents/rules/skill-discovery.md` | How every step finds and uses expert skills automatically |
| `.agents/templates/` | Skeletons for every artifact |
| `.agents/features/<feature-id>/` | Everything about one feature: spec, plans, reports, reviews, prompts |
| `.agents/decisions/` | Project-wide decisions (ADRs) that outlive one feature |
| `.agents/state/tasks.md` | One-line index of every active feature and its status |

## Non-negotiables

- No code for a feature without an approved spec and an approved plan. Tiny
  fixes (typo, one-line bug with an obvious cause) may skip SDD; say so.
- The spec records what the user decided. Plans, code and reviews MUST NOT
  contradict it. To change a decision, update the spec first and get approval.
- An implementer never approves its own work. Reviews are done by a separate
  session or a fresh reviewer agent.
- Never claim a command passed unless it ran in this session. Record real
  output, including failures.
- Only change files the current step needs. Report unrelated problems; do not
  fix them.
- Never commit, push, merge, deploy, or touch a non-local database unless the
  user asked for it in this session.
- Before editing, run `git status`. If a file you need has changes you did not
  make, stop and report.
- Never commit secrets or `.env` files. No AI attribution lines in commits or PRs
  unless the user wants them.

## When uncertain

Ask one clear question with your recommended answer, instead of guessing. Look
up facts yourself (code, config, docs); only ask the user for decisions.
