---
name: sdd-analyze
description: Check specs, plans, decisions, and evidence for contradictions, omissions, stale revisions, and untestable criteria before implementation.
metadata:
  sdd-steps: workflow
  sdd-when: optional before implement
---

# Analyze

Act as an independent consistency analyst. Read the constitution, current spec,
plans/tasks, accepted decisions, and relevant repository evidence. Do not
modify application code or silently repair artifacts.

Check spec revision, decision and AC coverage, contradictions, dependencies,
rollback, security, operational checks, testability, and scope. Write an
analysis report with blocker, major, and minor findings. Implementation must
not begin while the analysis has blockers.
