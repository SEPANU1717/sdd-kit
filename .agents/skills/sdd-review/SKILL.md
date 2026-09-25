---
name: sdd-review
description: Independently review an implementation against its spec, plan and the real diff, run the checks, and record a verdict. Use when the user asks to review, QA or approve a plan in .agents/features/, or when tasks.md shows ready-for-review.
metadata:
  sdd-steps: workflow
  sdd-when: this is an SDD step itself
---

# Review

## Role

You are the Reviewer. You judge; you do not fix. You must not review work you
implemented in this session.

You may write only:

- `.agents/features/<feature-id>/review-N-<slug>.md`
- your feature's line in `.agents/state/tasks.md`

You must not change code, tests, config, the spec, the plan or the
implementation report, and must not commit.

## Steps

1. **Read in full**: the feature's `spec.md`, the plan, the latest `impl-N`
   report, earlier review rounds, `AGENTS.md`, `.agents/rules/*.md`, and
   accepted decisions.
2. **Get the real diff.** Uncommitted: `git diff` and `git status` (include new
   files). Record the baseline or explicitly say it is unavailable. Use the
   exact diff scope as the truth; the report is only a guide.
3. **Run the checks** from `project.md` yourself and record real results.
4. **Check, in this order**:
   1. Spec decisions: nothing contradicts D1..Dn or an accepted ADR.
   2. Acceptance: each criterion this plan covers, with evidence
      (`path:line` or a test name).
   3. Scope: no changes outside the plan; no unrelated edits.
   4. Correctness and safety: server-side validation, authorization, money and
      data handling, error paths, migrations with rollback.
   5. Tests: the plan's listed behaviors are tested and meaningful.
   6. Rules: `project.md` conventions, file size, design rules if any.
5. **Write the round** in `review-N-<slug>.md` (template), with findings as
   blocker / major / minor and an exact required fix for each. Record reviewer
   independence, every AC/task mapping, and all unverified manual or
   operational checks.
6. **Verdict**:
   - `pass`: no blocker or major findings and all checks pass (or fail only for
     proven pre-existing reasons). Set `tasks.md` to `approved`, owner
     `implementer`, next step `/sdd-ship`.
   - `changes-requested`: set `tasks.md` accordingly, next step `/sdd-implement`
     (fix round).
   - `blocked`: something only the user can decide; ask it.
7. **Report** the verdict, the top findings and the next step.

## Rules

- Be specific: every finding points at a file and line and says what to do.
- Minor findings never block a pass; list them.
- Do not re-litigate spec decisions; if one looks wrong, raise it as `blocked`
  for the user.

## Expert skills

Follow `.agents/rules/skill-discovery.md` for the `review` step: find applicable skills automatically (index plus folder scan), apply them as that file describes, and name them in your report.
