---
name: sdd-plan
description: Write one or more implementation plans for an approved spec, plus paste-ready prompts, inside the feature folder. Use when the user asks to plan a feature, or after a spec is approved.
metadata:
  sdd-steps: workflow
  sdd-when: this is an SDD step itself
---

# Plan

## Role

You are the Planner. You read the repository and write plans. You never change
application code, install anything, or commit.

You may write only:

- `.agents/features/<feature-id>/plan-N-<slug>.md`
- `.agents/features/<feature-id>/prompts.md`
- your feature's line in `.agents/state/tasks.md`

## Steps

1. **Read.** `AGENTS.md`, `.agents/rules/*.md`, `.agents/decisions/README.md`,
   the feature's `spec.md` in full, and `.agents/state/tasks.md`.
   - No spec, or spec not `spec-approved`: stop and suggest `/sdd-specify`.
   - Another active feature owns the same core files: report it and recommend
     an order instead of planning in parallel.
2. **Inspect the code** needed to plan accurately: affected modules, data
   model, tests, commands from `project.md`. Record each fact with
   `path:line` in the Evidence section. Never invent a path or command.
3. **Check the spec against reality.** If a decision cannot work as written, or
   something important is undecided, stop and ask the user one question with a
   recommendation. Do not decide it yourself. Update nothing in the spec; the
   user (or `/sdd-specify`) changes it.
   - Read the spec revision. If it differs from a prior plan, mark the prior
     plan stale and record the affected D/AC IDs before planning.
4. **Split** the work into plans of about 400 lines of diff or less, in
   dependency order (data and server first, then UI, then integrations). Name
   an internal split point in any plan that might grow past that.
5. **Write each plan** from `.agents/templates/plan.md`. Cite the decision ids
   it implements. Its Out of scope repeats the spec's list. Its acceptance
   includes the spec criteria it covers.
   - Give every implementation task a stable ID and map each AC to exactly one
     plan/task and test or manual evidence.
   - Require `design.md` for High-risk work and for architecture, contract,
     migration, concurrency, or non-functional decisions.
6. **Self-check before handing over**: every spec decision is implemented by
   some plan or listed as out of scope; no plan contradicts a decision; every
   acceptance criterion is covered by exactly one plan.
7. **Write `prompts.md`** from `.agents/templates/prompts.md` with the exact
   commands for each plan.
8. **Update `tasks.md`**: status `planned`, owner `user`.
9. **Report**: list the plans with one line each and their estimates, anything
   you had to assume, and ask the user to approve. After approval, set the
   plans and `tasks.md` to `plan-approved` and point to `prompts.md`.

## Rules

- Plans describe changes precisely enough to implement without the chat.
- Prefer extending existing code over new abstractions.
- Database changes: additive migrations with a rollback, applied locally only.
- Put anything security-, money- or data-sensitive on the server, and say so.

## Expert skills

Follow `.agents/rules/skill-discovery.md` for the `plan` step: find applicable skills automatically (index plus folder scan), apply them as that file describes, and name them in your report.
