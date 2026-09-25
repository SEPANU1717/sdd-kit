---
artifact: checklist
schema: 1
feature: <YYYYMMDD-slug>
revision: 1
status: draft
risk: standard
---

# Quality checklist: <feature title>

- Feature: `.agents/features/<feature-id>/spec.md`
- Spec revision: <integer>
- Reviewed by: <agent/session or human>

## Requirement quality

- [ ] Problem is evidenced by the repository or user-provided evidence.
- [ ] Every decision has a stable ID and a reason.
- [ ] Every acceptance criterion is observable and has one behavior.
- [ ] Out-of-scope items are explicit.
- [ ] Security, privacy, accessibility, performance, observability, and rollback
      are addressed or marked not applicable with a reason.

## Consistency

- [ ] Plan uses the current spec revision.
- [ ] Every AC maps to exactly one plan and task.
- [ ] No plan contradicts a decision or accepted ADR.
- [ ] Dependencies and split points are explicit.
- [ ] Tests or manual evidence exist for every AC.

## Result

- Verdict: pass | changes-requested | blocked
- Findings: <...>
