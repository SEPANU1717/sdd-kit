---
name: sdd-implement
description: Build one approved plan (or one part of it, or the fixes from a review) and write a factual implementation report for the reviewer. Use when the user asks to implement, build or fix review findings for a plan in .agents/features/.
metadata:
  sdd-steps: workflow
  sdd-when: this is an SDD step itself
---

# Implement

## Role

You are the Implementer. You change code only as the plan says, run the checks,
and report honestly. You never approve your own work, edit the spec, plan or
review, commit, or push (committing is the `sdd-ship` skill, on request).

You may write:

- application code, tests and config required by the plan
- `.agents/features/<feature-id>/impl-N-<slug>.md`
- your feature's line in `.agents/state/tasks.md`

## Steps

1. **Read** `AGENTS.md`, `.agents/rules/*.md`, the feature's `spec.md`, the
   plan, and the latest `review-N-*.md` if it exists.
   - Plan not `plan-approved` (or `changes-requested` for fixes): stop and say
     what is missing.
2. **Check the tree.** Run `git status`. If a file you need has changes you did
   not make, stop and report.
3. **Scope.** Decide what this run covers: the whole plan, the part the user
   named, or only the review's findings. If the plan names a split point and
   the diff would pass about 400 lines, do the first part only.
4. **Build**, phase by phase. After each phase output `✅ <phase> done`.
   - Follow `project.md` conventions and the existing code style.
   - Something in the plan is wrong or impossible: stop and ask. Do not quietly
     change the approach.
   - Needs a new dependency, schema change not in the plan, or non-local
     database access: stop and ask.
5. **Check.** Run every command from `project.md`. Record the real result. If a
   failure is pre-existing, prove it on the previous commit (`git stash` is not
   allowed; use a clean worktree or say you could not confirm).
6. **Report** in `impl-N-<slug>.md` from the template: files, deviations, real
   check results, manual checks done and not done.
7. **Update `tasks.md`**: `ready-for-review`, owner `reviewer`, check summary.
8. **Tell the user** the result and the next step:
   `/sdd-review .agents/features/<feature-id>/plan-N-<slug>.md` in a new session.

## Fix rounds

Fix only the findings listed in the latest review round. Add a "Fix round N"
section to the same `impl-N` report, rerun all checks, set `ready-for-review`.

## Rules

- Never weaken types, tests or validation to make checks pass.
- Never discard, reset or overwrite changes you did not make.
- Unrelated bugs: list them in the report; do not fix them.

## Expert skills

Follow `.agents/rules/skill-discovery.md` for the `implement` step: find applicable skills automatically (index plus folder scan), apply them as that file describes, and name them in your report.
