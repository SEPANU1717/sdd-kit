# SDD Workflow

## The lifecycle

```
idea ─► SPEC ─► PLAN ─► IMPLEMENT ─► REVIEW ─► SHIP
         │        │         │           │        │
      spec.md  plan-N.md  impl-N.md  review-N.md commit
      (user     (user                  (pass or
     approves) approves)              changes)
```

Optional quality gates fit around the core flow:

```text
SPEC ─► CLARIFY ─► CHECKLIST ─► PLAN ─► ANALYZE ─► IMPLEMENT ─► REVIEW ─► CONVERGE ─► SHIP
```

Use them for ambiguous, high-risk, or acceptance-heavy work. They are not a
reason to add ceremony to a Quick-lane change.

| Step | Skill | Role | Writes | Gate to leave the step |
| --- | --- | --- | --- | --- |
| Spec | `sdd-specify` | Analyst | `spec.md`, `decisions/*.md` (proposed) | User says the spec is approved |
| Plan | `sdd-plan` | Planner | `plan-N-<slug>.md`, `prompts.md` | User approves the plan(s) |
| Implement | `sdd-implement` | Implementer | code, tests, `impl-N-<slug>.md` | All checks ran; report written |
| Review | `sdd-review` | Reviewer | `review-N-<slug>.md` | Verdict `pass` |
| Ship | `sdd-ship` | Implementer | a commit | User asked to commit |

`sdd-status` is read-only and can run at any time.

## Feature folder

One folder per feature: `.agents/features/<feature-id>/`

- Feature id: `YYYYMMDD-kebab-slug` (date the spec was started).
- Files:
  - `spec.md`: the what and why. One per feature.
  - `plan-1-<slug>.md`, `plan-2-<slug>.md` ...: the how. Split a feature into
    several plans when it would exceed about 400 lines of diff.
  - `impl-N-<slug>.md`: what was built for plan N, with command results.
  - `review-N-<slug>.md`: reviewer verdicts for plan N, one section per round.
  - `prompts.md`: paste-ready prompts to run each plan in a new session.

## Statuses (in `.agents/state/tasks.md`)

| Status | Meaning | Next owner |
| --- | --- | --- |
| `specifying` | Questions still open | user + analyst |
| `spec-approved` | Decisions locked | planner |
| `planned` | Plans written, waiting for user | user |
| `plan-approved` | Ready to build | implementer |
| `in-progress` | Being built | implementer |
| `ready-for-review` | Built, checks ran | reviewer |
| `changes-requested` | Review found problems | implementer |
| `approved` | Review passed | implementer (ship) |
| `done` | Committed | nobody |
| `blocked` | Waiting on something named in the entry | named person |
| `stale` | A derived artifact targets an older spec revision | planner |
| `cancelled` | Work deliberately stopped; preserve the reason | nobody |

A multi-plan feature shows the status of its current plan, for example
`in-progress (plan 2 of 3)`.

## File ownership

Only the owner edits a file. Everyone else reads it.

| File | Owner | Others |
| --- | --- | --- |
| `spec.md` | analyst (user approves) | read-only; request changes through the user |
| `plan-N-*.md` | planner (user approves) | read-only |
| `impl-N-*.md` | implementer | read-only |
| `review-N-*.md` | reviewer | read-only |
| `prompts.md` | planner | read-only |
| `decisions/*.md` | analyst or planner propose, user accepts | read-only |
| `state/tasks.md` | each role updates only its feature's line | |

## Rules between steps

- A plan links to its spec and must not contradict any decision in it. If a
  decision is wrong or missing, the planner asks the user and the spec is
  updated first.
- `spec.md` is the current contract. An approved change increments its revision,
  records affected D/AC IDs, and marks derived plans stale until revalidated.
- The implementer builds only what the plan lists. New scope goes back to the
  plan (and the spec, if a decision changes).
- The reviewer checks code against the plan AND the spec's acceptance criteria,
  using the real diff, and runs the checks itself.
- Three failed review rounds on the same plan: stop and ask the user.
- Every AC maps to one plan and task, plus test or manual evidence. An explicit
  justified exception is required for non-testable criteria.
- One feature at a time touches a given file. If two features need the same
  file, finish and ship one first.

## Skipping SDD

Allowed for: typos, copy changes, dependency-free one-line fixes with an
obvious cause, and pure investigation. Say "skipping SDD: <reason>" and still
run the checks.

## Housekeeping

- Keep `tasks.md` short: move `done` lines to `.agents/state/archive/YYYY-MM.md`
  at the start of each month.
- Feature folders stay forever as history. Never delete them.
