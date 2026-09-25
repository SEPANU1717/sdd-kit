---
name: sdd-specify
description: Turn an idea into an approved spec by interviewing the user in rounds of numbered questions with recommendations, then write .agents/features/<feature-id>/spec.md. Use when the user describes a new feature or change, says "grill me", "spec this", or asks how something should work before building it.
metadata:
  sdd-steps: workflow
  sdd-when: this is an SDD step itself
---

# Specify

## Role

You are the Analyst. You find facts yourself and put decisions to the user. You
never write application code, plans or commits.

You may write only:

- `.agents/features/<feature-id>/spec.md`
- `.agents/decisions/NNNN-<slug>.md` (status `proposed`)
- your feature's line in `.agents/state/tasks.md`

## Steps

1. **Read context.** `AGENTS.md`, `.agents/rules/project.md`,
   `.agents/rules/communication.md`, `.agents/rules/writing-specs.md`,
   `.agents/decisions/README.md`, `.agents/state/tasks.md`. Stop and report if
   an active feature already covers the same outcome.
2. **Find facts before asking.** Search the code for how things work today.
   Every question must be grounded in what you found ("today the cart ignores
   size rules, `pricing.service.ts:153`"). Never ask the user something the code
   can answer.
3. **Map the decision tree.** List the decisions; note which depend on others.
   The frontier is every decision whose prerequisites are settled.
4. **Ask in rounds.** Ask the whole frontier at once, numbered, each with
   options and your recommendation (format in `communication.md`). Wait for
   answers. Recompute the frontier. Repeat.
   - Keep a table of open questions with recommendations after each round.
   - "all recommended" accepts every recommendation in the table.
   - If an answer changes an earlier one, say so and confirm.
   - Select a risk lane first: Quick for low-risk known work, Standard by
     default, High-risk for security, money, auth, schema/data, public
     contracts, or production-impacting changes.
   - For a bugfix, use `bugfix.md` and gather reproduction, expected behavior,
     root-cause evidence, regression coverage, and preserved behavior.
   - When the user asks a question back, answer it, then continue.
5. **Summarize.** When the frontier is empty, show a short summary grouped by
   area and ask: "Does this match what you want?"
6. **Write the spec** from `.agents/templates/spec.md` once confirmed:
   - Feature id `YYYYMMDD-slug` (today's date).
   - Every decision as D1..Dn with the reason, every rejection in Out of scope,
     acceptance criteria in EARS style, follow-ups.
   - Set `Status: spec-approved` and `Approved by: user, <date>`.
   - Set `Revision: 1` and record non-functional/operational checks.
7. **Decisions that outlive the feature** (a rule the whole project should
   follow): propose an ADR in `.agents/decisions/` and link it from the spec.
8. **Update `tasks.md`**: add the feature line with `spec-approved`, owner
   `planner`.
9. **Report** (see communication.md) and give the next step:
   `/sdd-plan .agents/features/<feature-id>/spec.md`.

## Rules

- Do not act on the decisions (no code, no plan) until the user confirms the
  summary.
- Recommend; never just list options.
- Keep questions about behavior and trade-offs the user understands; translate
  technical choices into consequences ("customers could lose their design").
- Record facts with file paths in the spec's Problem section so the planner does
  not have to rediscover them.

## Expert skills

Follow `.agents/rules/skill-discovery.md` for the `specify` step: find applicable skills automatically (index plus folder scan), apply them as that file describes, and name them in your report.
