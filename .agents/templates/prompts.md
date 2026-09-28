# Prompts: <feature title>

Planner: use `.agents/skills/prompt-master/SKILL.md` for concise wording, but
keep these stage gates and outputs. Replace every placeholder, including the
spec revision. Duplicate the plan section for each plan in dependency order.
Keep each block standalone and tool-neutral; the artifacts are the context, so
do not paste their contents here. Give each block to a new session or agent at
its gate.

## Plan <N>: <title>

### Implement (after user approves this plan)

```text
Use the sdd-implement skill in .agents/skills/sdd-implement/SKILL.md for .agents/features/<feature-id>/plan-<N>-<slug>.md (spec revision <R>). Read AGENTS.md, the spec, the plan, and any linked design. Confirm the plan is approved and run the read-only SDD doctor before editing. Implement only this plan; run applicable local checks, record AC evidence in impl-<N>-<slug>.md, and stop at ready-for-review. Do not commit or perform scoped external operations without authorization.
```

### Review (fresh reviewer, after implementation)

```text
Use the sdd-review skill in .agents/skills/sdd-review/SKILL.md for .agents/features/<feature-id>/plan-<N>-<slug>.md (spec revision <R>). Independently inspect the spec, plan, implementation report, and real diff. Run applicable local checks; record findings, AC evidence, and unverified items in review-<N>-<slug>.md. Give a pass only when its gate is met. Do not edit implementation code or commit.
```

### Ship (only after a pass and explicit user request to commit)

```text
Use the sdd-ship skill in .agents/skills/sdd-ship/SKILL.md for .agents/features/<feature-id>/plan-<N>-<slug>.md (spec revision <R>). Verify the latest independent review passed and the user authorized this commit. Stage only the plan's reviewed files, scan the staged diff for secrets, commit, and report the hash and remaining status. Do not push, merge, or deploy unless separately requested.
```
